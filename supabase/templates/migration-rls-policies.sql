-- Migration: RLS Policies Template
-- Save to: supabase/migrations/<timestamp>_<name>.sql

-- Enable RLS on table (required before adding policies)
ALTER TABLE public.your_table ENABLE ROW LEVEL SECURITY;

-- Force RLS for table owners too (optional, but recommended)
ALTER TABLE public.your_table FORCE ROW LEVEL SECURITY;

-- ============================================
-- BASIC USER-OWNED DATA POLICIES
-- ============================================

-- SELECT: Users can read their own records
CREATE POLICY "select_own_records"
    ON public.your_table
    FOR SELECT
    TO authenticated
    USING (auth.uid() = user_id);

-- INSERT: Users can create records for themselves
CREATE POLICY "insert_own_records"
    ON public.your_table
    FOR INSERT
    TO authenticated
    WITH CHECK (auth.uid() = user_id);

-- UPDATE: Users can update their own records
CREATE POLICY "update_own_records"
    ON public.your_table
    FOR UPDATE
    TO authenticated
    USING (auth.uid() = user_id)
    WITH CHECK (auth.uid() = user_id);

-- DELETE: Users can delete their own records  
CREATE POLICY "delete_own_records"
    ON public.your_table
    FOR DELETE
    TO authenticated
    USING (auth.uid() = user_id);

-- ============================================
-- PUBLIC READ ACCESS
-- ============================================

-- Allow anyone to read public records
CREATE POLICY "select_public_records"
    ON public.your_table
    FOR SELECT
    TO anon, authenticated
    USING (is_public = true);

-- ============================================
-- ORGANIZATION/TEAM-BASED ACCESS
-- ============================================

-- Users can read records from their organization
CREATE POLICY "select_org_records"
    ON public.your_table
    FOR SELECT
    TO authenticated
    USING (
        org_id IN (
            SELECT org_id FROM public.org_members 
            WHERE user_id = auth.uid()
        )
    );

-- ============================================
-- ROLE-BASED ACCESS
-- ============================================

-- Check if user has admin role
CREATE OR REPLACE FUNCTION public.is_admin()
RETURNS BOOLEAN AS $$
BEGIN
    RETURN EXISTS (
        SELECT 1 FROM public.user_roles
        WHERE user_id = auth.uid()
        AND role = 'admin'
    );
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Admins can do anything
CREATE POLICY "admin_full_access"
    ON public.your_table
    FOR ALL
    TO authenticated
    USING (public.is_admin())
    WITH CHECK (public.is_admin());

-- ============================================
-- SERVICE ROLE BYPASS
-- ============================================

-- Service role (used by Edge Functions with service key) bypasses RLS automatically
-- No policy needed, but you can be explicit:
CREATE POLICY "service_role_bypass"
    ON public.your_table
    FOR ALL
    TO service_role
    USING (true)
    WITH CHECK (true);

-- ============================================
-- DROPPING POLICIES
-- ============================================

-- Drop a specific policy
-- DROP POLICY IF EXISTS "policy_name" ON public.your_table;

-- ============================================
-- VIEWING EXISTING POLICIES
-- ============================================

-- View all policies for a table:
-- SELECT * FROM pg_policies WHERE tablename = 'your_table';
