import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2.38.4"

const supabaseUrl = Deno.env.get('SUPABASE_URL')!
const supabaseServiceKey = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!

interface EscalationRequest {
  task_id: string
  cost: number
  category: string
  description: string
  engineer_id: string
}

serve(async (req) => {
  // Handle CORS preflight request
  if (req.method === 'OPTIONS') {
    return new Response(null, {
      headers: {
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Methods': 'POST, OPTIONS',
        'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
      },
    })
  }

  try {
    // Only allow POST requests
    if (req.method !== 'POST') {
      return new Response(JSON.stringify({ error: 'Method not allowed' }), {
        status: 405,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
        },
      })
    }

    const { task_id, cost, category, description, engineer_id }: EscalationRequest = await req.json()

    // Validate required fields
    if (!task_id || !cost || !category || !description || !engineer_id) {
      return new Response(JSON.stringify({ error: 'Missing required fields' }), {
        status: 400,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
        },
      })
    }

    // Initialize Supabase client with service role key
    const supabase = createClient(supabaseUrl, supabaseServiceKey)

    // Get task details
    const { data: task, error: taskError } = await supabase
      .from('tasks')
      .select('title, assigned_to, team_id')
      .eq('id', task_id)
      .single()

    if (taskError || !task) {
      return new Response(JSON.stringify({ error: 'Task not found' }), {
        status: 404,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
        },
      })
    }

    // Determine approval status based on cost threshold
    const COST_THRESHOLD = 500000
    const approvalStatus = cost > COST_THRESHOLD ? 'pending_manager' : 'approved'

    // Update task with escalation details
    const { error: updateError } = await supabase
      .from('tasks')
      .update({
        approval_status: approvalStatus,
        escalation_cost: cost,
        escalation_category: category,
        escalation_description: description,
        escalated_at: new Date().toISOString(),
      })
      .eq('id', task_id)

    if (updateError) {
      return new Response(JSON.stringify({ error: 'Failed to update task' }), {
        status: 500,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
        },
      })
    }

    // Send notification based on approval status
    if (approvalStatus === 'pending_manager') {
      // Notify all managers
      const { data: managers } = await supabase
        .from('users')
        .select('id')
        .eq('role', 'manager')

      if (managers && managers.length > 0) {
        const notifications = managers.map((manager: any) => ({
          user_id: manager.id,
          title: 'Eskalasi Butuh Approval',
          message: `Eskalasi untuk tugas "${task.title}" melebihi plafon Rp500.000. Biaya: Rp${cost.toLocaleString('id-ID')}. Butuh approval Anda.`,
          type: 'approval',
          is_read: false,
        }))

        await supabase.from('notifications').insert(notifications)
      }
    } else {
      // Auto-approved: notify engineer
      await supabase.from('notifications').insert({
        user_id: engineer_id,
        title: 'Eskalasi Disetujui Otomatis',
        message: `Eskalasi untuk tugas "${task.title}" telah disetujui otomatis oleh sistem karena biaya Rp${cost.toLocaleString('id-ID')} tidak melebihi plafon.`,
        type: 'escalation',
        is_read: false,
      })
    }

    return new Response(
      JSON.stringify({
        success: true,
        approval_status: approvalStatus,
        message: approvalStatus === 'pending_manager'
          ? 'Eskalasi melebihi plafon. Menunggu approval manager.'
          : 'Eskalasi disetujui otomatis oleh sistem.',
      }),
      {
        status: 200,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
        },
      }
    )
  } catch (error) {
    console.error('Error in escalate function:', error)
    return new Response(
      JSON.stringify({ error: 'Internal server error' }),
      {
        status: 500,
        headers: {
          'Access-Control-Allow-Origin': '*',
          'Content-Type': 'application/json',
        },
      }
    )
  }
})
