import { serve } from "https://deno.land/std@0.168.0/http/server.ts"
import { createClient } from "https://esm.sh/@supabase/supabase-js@2"

const GEMINI_API_KEY = Deno.env.get('GEMINI_API_KEY') || ''
const GEMINI_EMBEDDING_URL = 'https://generativelanguage.googleapis.com/v1beta/models/text-embedding-004:embedContent'
const GEMINI_GENERATION_URL = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:streamGenerateContent'

serve(async (req) => {
  if (req.method !== 'POST') {
    return new Response('Method not allowed', { status: 405 })
  }

  try {
    const { query } = await req.json()

    if (!query) {
      return new Response('Query is required', { status: 400 })
    }

    // Step 1: Create embedding from query using Gemini
    const embeddingResponse = await fetch(`${GEMINI_EMBEDDING_URL}?key=${GEMINI_API_KEY}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        content: {
          parts: [{ text: query }]
        }
      })
    })

    const embeddingData = await embeddingResponse.json()
    const embedding = embeddingData.embedding.values

    // Step 2: Query Supabase for relevant chunks using pgvector
    const supabase = createClient(
      Deno.env.get('SUPABASE_URL') ?? '',
      Deno.env.get('SUPABASE_ANON_KEY') ?? ''
    )

    const { data: chunks, error } = await supabase
      .rpc('match_knowledge_chunks', {
        query_embedding: embedding,
        match_threshold: 0.78,
        match_count: 5
      })

    if (error) {
      console.error('Supabase query error:', error)
      return new Response('Failed to query knowledge base', { status: 500 })
    }

    // Step 3: Construct context from retrieved chunks
    const context = chunks
      .map((chunk: any) => chunk.content)
      .join('\n\n')

    // Step 4: Construct system prompt
    const systemPrompt = `Anda adalah Si MaTa, asisten AI internal PT Telkomsel NBAD. Tugas Anda adalah membantu teknisi lapangan memahami alur kerja ABB (Access Broadband Build) mulai dari Input Order, Penggelaran, hingga On-Air. Jawablah HANYA berdasarkan dokumen SOP internal dan K3 yang dilampirkan. Jika ditanya di luar SOP, tolak dengan sopan. Jangan pernah mengarang jawaban (halusinasi).\n\nKonteks SOP:\n${context}`

    // Step 5: Stream response from Gemini 1.5 Flash
    const geminiResponse = await fetch(`${GEMINI_GENERATION_URL}?key=${GEMINI_API_KEY}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({
        contents: [{
          parts: [{ text: `${systemPrompt}\n\nPertanyaan: ${query}` }]
        }],
        generationConfig: {
          temperature: 0.7,
          maxOutputTokens: 2048
        }
      })
    })

    if (!geminiResponse.ok) {
      const errorText = await geminiResponse.text()
      console.error('Gemini API error:', errorText)
      return new Response('Failed to generate response', { status: 500 })
    }

    // Step 6: Return as SSE
    const stream = geminiResponse.body
    const readableStream = new ReadableStream({
      async start(controller) {
        const reader = stream!.getReader()
        const decoder = new TextDecoder()

        try {
          while (true) {
            const { done, value } = await reader.read()
            if (done) break

            const chunk = decoder.decode(value)
            controller.enqueue(new TextEncoder().encode(chunk))
          }
        } catch (error) {
          console.error('Stream error:', error)
        } finally {
          controller.close()
        }
      }
    })

    return new Response(readableStream, {
      headers: {
        'Content-Type': 'text/event-stream',
        'Cache-Control': 'no-cache',
        'Connection': 'keep-alive'
      }
    })

  } catch (error) {
    console.error('Error:', error)
    return new Response('Internal server error', { status: 500 })
  }
})
