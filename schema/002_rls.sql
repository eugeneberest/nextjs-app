-- Enable RLS
ALTER TABLE brands ENABLE ROW LEVEL SECURITY;
ALTER TABLE models ENABLE ROW LEVEL SECURITY;
ALTER TABLE trims ENABLE ROW LEVEL SECURITY;
ALTER TABLE powertrains ENABLE ROW LEVEL SECURITY;
ALTER TABLE tco_params ENABLE ROW LEVEL SECURITY;

-- Public read for all
CREATE POLICY IF NOT EXISTS "Allow public read" ON brands FOR SELECT USING (true);
CREATE POLICY IF NOT EXISTS "Allow public read" ON models FOR SELECT USING (true);
CREATE POLICY IF NOT EXISTS "Allow public read" ON trims FOR SELECT USING (true);
CREATE POLICY IF NOT EXISTS "Allow public read" ON powertrains FOR SELECT USING (true);
CREATE POLICY IF NOT EXISTS "Allow public read" ON tco_params FOR SELECT USING (true);

-- Service role full access
CREATE POLICY IF NOT EXISTS "Service role all" ON brands FOR ALL USING (auth.role() = 'service_role');
CREATE POLICY IF NOT EXISTS "Service role all" ON models FOR ALL USING (auth.role() = 'service_role');
CREATE POLICY IF NOT EXISTS "Service role all" ON trims FOR ALL USING (auth.role() = 'service_role');
CREATE POLICY IF NOT EXISTS "Service role all" ON powertrains FOR ALL USING (auth.role() = 'service_role');
CREATE POLICY IF NOT EXISTS "Service role all" ON tco_params FOR ALL USING (auth.role() = 'service_role');