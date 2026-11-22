-- Migration: Extend Schema with Additional Tables
-- This migration adds 5 new tables to complement the existing 10 tables

-- Table: task_replies
-- Stores replies/comments on tasks
CREATE TABLE IF NOT EXISTS task_replies (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    message TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for faster queries
CREATE INDEX idx_task_replies_task_id ON task_replies(task_id);
CREATE INDEX idx_task_replies_user_id ON task_replies(user_id);
CREATE INDEX idx_task_replies_created_at ON task_replies(created_at DESC);

-- Table: file_repository
-- Stores file attachments for tasks (before/after photos, documents, etc.)
CREATE TABLE IF NOT EXISTS file_repository (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    file_name VARCHAR(255) NOT NULL,
    file_url TEXT NOT NULL,
    file_type VARCHAR(50) NOT NULL, -- 'image', 'document', 'audio', 'video'
    uploaded_by UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for faster queries
CREATE INDEX idx_file_repository_task_id ON file_repository(task_id);
CREATE INDEX idx_file_repository_uploaded_by ON file_repository(uploaded_by);
CREATE INDEX idx_file_repository_file_type ON file_repository(file_type);

-- Table: notifications
-- Stores user notifications
CREATE TABLE IF NOT EXISTS notifications (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL, -- 'task', 'escalation', 'system', 'approval'
    is_read BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for faster queries
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);
CREATE INDEX idx_notifications_type ON notifications(type);
CREATE INDEX idx_notifications_created_at ON notifications(created_at DESC);

-- Table: feedbacks
-- Stores feedback/ratings for completed tasks
CREATE TABLE IF NOT EXISTS feedbacks (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    engineer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    rating INTEGER NOT NULL CHECK (rating >= 1 AND rating <= 5),
    notes TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for faster queries
CREATE INDEX idx_feedbacks_task_id ON feedbacks(task_id);
CREATE INDEX idx_feedbacks_engineer_id ON feedbacks(engineer_id);
CREATE INDEX idx_feedbacks_rating ON feedbacks(rating);

-- Table: smart_recommendations
-- Stores AI-generated recommendations for tasks
CREATE TABLE IF NOT EXISTS smart_recommendations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    task_id UUID NOT NULL REFERENCES tasks(id) ON DELETE CASCADE,
    recommendation_text TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Index for faster queries
CREATE INDEX idx_smart_recommendations_task_id ON smart_recommendations(task_id);
CREATE INDEX idx_smart_recommendations_created_at ON smart_recommendations(created_at DESC);

-- Enable Row Level Security (RLS)
ALTER TABLE task_replies ENABLE ROW LEVEL SECURITY;
ALTER TABLE file_repository ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;
ALTER TABLE feedbacks ENABLE ROW LEVEL SECURITY;
ALTER TABLE smart_recommendations ENABLE ROW LEVEL SECURITY;

-- RLS Policies for task_replies
CREATE POLICY "Users can view task replies for their tasks"
    ON task_replies FOR SELECT
    USING (
        task_id IN (
            SELECT id FROM tasks WHERE assigned_to = auth.uid()
            OR EXISTS (
                SELECT 1 FROM team_members WHERE team_id = tasks.team_id AND user_id = auth.uid()
            )
        )
    );

CREATE POLICY "Users can create task replies"
    ON task_replies FOR INSERT
    WITH CHECK (
        task_id IN (
            SELECT id FROM tasks WHERE assigned_to = auth.uid()
            OR EXISTS (
                SELECT 1 FROM team_members WHERE team_id = tasks.team_id AND user_id = auth.uid()
            )
        )
        AND user_id = auth.uid()
    );

-- RLS Policies for file_repository
CREATE POLICY "Users can view files for their tasks"
    ON file_repository FOR SELECT
    USING (
        task_id IN (
            SELECT id FROM tasks WHERE assigned_to = auth.uid()
            OR EXISTS (
                SELECT 1 FROM team_members WHERE team_id = tasks.team_id AND user_id = auth.uid()
            )
        )
    );

CREATE POLICY "Users can upload files"
    ON file_repository FOR INSERT
    WITH CHECK (
        task_id IN (
            SELECT id FROM tasks WHERE assigned_to = auth.uid()
            OR EXISTS (
                SELECT 1 FROM team_members WHERE team_id = tasks.team_id AND user_id = auth.uid()
            )
        )
        AND uploaded_by = auth.uid()
    );

-- RLS Policies for notifications
CREATE POLICY "Users can view their own notifications"
    ON notifications FOR SELECT
    USING (user_id = auth.uid());

CREATE POLICY "Users can update their own notifications"
    ON notifications FOR UPDATE
    USING (user_id = auth.uid());

-- RLS Policies for feedbacks
CREATE POLICY "Users can view feedbacks"
    ON feedbacks FOR SELECT
    USING (
        task_id IN (
            SELECT id FROM tasks WHERE assigned_to = auth.uid()
            OR EXISTS (
                SELECT 1 FROM team_members WHERE team_id = tasks.team_id AND user_id = auth.uid()
            )
        )
    );

CREATE POLICY "Users can create feedbacks"
    ON feedbacks FOR INSERT
    WITH CHECK (
        task_id IN (
            SELECT id FROM tasks WHERE assigned_to = auth.uid()
            OR EXISTS (
                SELECT 1 FROM team_members WHERE team_id = tasks.team_id AND user_id = auth.uid()
            )
        )
        AND engineer_id = auth.uid()
    );

-- RLS Policies for smart_recommendations
CREATE POLICY "Users can view recommendations for their tasks"
    ON smart_recommendations FOR SELECT
    USING (
        task_id IN (
            SELECT id FROM tasks WHERE assigned_to = auth.uid()
            OR EXISTS (
                SELECT 1 FROM team_members WHERE team_id = tasks.team_id AND user_id = auth.uid()
            )
        )
    );

-- Function to trigger notification on escalation approval
CREATE OR REPLACE FUNCTION notify_escalation_approval()
RETURNS TRIGGER AS $$
BEGIN
    IF NEW.approval_status = 'approved' THEN
        INSERT INTO notifications (user_id, title, message, type)
        SELECT 
            NEW.assigned_to,
            'Eskalasi Disetujui',
            CONCAT('Eskalasi untuk tugas ', NEW.title, ' telah disetujui oleh sistem.'),
            'escalation'
        WHERE NEW.assigned_to IS NOT NULL;
    ELSIF NEW.approval_status = 'pending_manager' THEN
        -- Notify all managers
        INSERT INTO notifications (user_id, title, message, type)
        SELECT 
            u.id,
            'Eskalasi Butuh Approval',
            CONCAT('Eskalasi untuk tugas ', NEW.title, ' melebihi plafon Rp500.000. Butuh approval Anda.'),
            'approval'
        FROM users u
        WHERE u.role = 'manager';
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to call notification function on task update
DROP TRIGGER IF EXISTS on_task_approval_update ON tasks;
CREATE TRIGGER on_task_approval_update
    AFTER UPDATE OF approval_status ON tasks
    FOR EACH ROW
    EXECUTE FUNCTION notify_escalation_approval();
