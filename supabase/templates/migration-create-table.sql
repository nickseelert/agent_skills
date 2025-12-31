-- Migration: Create Table Template
-- Save to: supabase/migrations/<timestamp>_<name>.sql

-- Create the table
CREATE TABLE IF NOT EXISTS public.your_table (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    created_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    updated_at TIMESTAMPTZ DEFAULT now() NOT NULL,
    
    -- Add your columns here
    name TEXT NOT NULL,
    description TEXT,
    status TEXT DEFAULT 'active' CHECK (status IN ('active', 'inactive', 'deleted')),
    
    -- Foreign key example
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE
);

-- Create updated_at trigger
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$ language 'plpgsql';

CREATE TRIGGER update_your_table_updated_at
    BEFORE UPDATE ON public.your_table
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Add indexes
CREATE INDEX IF NOT EXISTS idx_your_table_user_id ON public.your_table(user_id);
CREATE INDEX IF NOT EXISTS idx_your_table_status ON public.your_table(status);
CREATE INDEX IF NOT EXISTS idx_your_table_created_at ON public.your_table(created_at DESC);

-- Enable RLS
ALTER TABLE public.your_table ENABLE ROW LEVEL SECURITY;

-- RLS Policies
-- Allow users to read their own records
CREATE POLICY "Users can view own records"
    ON public.your_table
    FOR SELECT
    USING (auth.uid() = user_id);

-- Allow users to insert their own records
CREATE POLICY "Users can insert own records"
    ON public.your_table
    FOR INSERT
    WITH CHECK (auth.uid() = user_id);

-- Allow users to update their own records
CREATE POLICY "Users can update own records"
    ON public.your_table
    FOR UPDATE
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- Allow users to delete their own records
CREATE POLICY "Users can delete own records"
    ON public.your_table
    FOR DELETE
    USING (auth.uid() = user_id);

-- Grant permissions
GRANT ALL ON public.your_table TO authenticated;
GRANT SELECT ON public.your_table TO anon;

-- Comment the table
COMMENT ON TABLE public.your_table IS 'Description of what this table stores';
