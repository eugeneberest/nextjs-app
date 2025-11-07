-- Enable RLS
ALTER TABLE brands ENABLE ROW LEVEL SECURITY;
ALTER TABLE models ENABLE ROW LEVEL SECURITY;
ALTER TABLE trims ENABLE ROW LEVEL SECURITY;
ALTER TABLE powertrains ENABLE ROW LEVEL SECURITY;
ALTER TABLE tco_params ENABLE ROW LEVEL SECURITY;

-- Public read for all
DROP POLICY IF EXISTS "Allow public read" ON brands;
CREATE POLICY "Allow public read" ON brands FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow public read" ON models;
CREATE POLICY "Allow public read" ON models FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow public read" ON trims;
CREATE POLICY "Allow public read" ON trims FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow public read" ON powertrains;
CREATE POLICY "Allow public read" ON powertrains FOR SELECT USING (true);
DROP POLICY IF EXISTS "Allow public read" ON tco_params;
CREATE POLICY "Allow public read" ON tco_params FOR SELECT USING (true);

-- Service role full access
DROP POLICY IF EXISTS "Service role all" ON brands;
CREATE POLICY "Service role all" ON brands FOR ALL USING (auth.role() = 'service_role');
DROP POLICY IF EXISTS "Service role all" ON models;
CREATE POLICY "Service role all" ON models FOR ALL USING (auth.role() = 'service_role');
DROP POLICY IF EXISTS "Service role all" ON trims;
CREATE POLICY "Service role all" ON trims FOR ALL USING (auth.role() = 'service_role');
DROP POLICY IF EXISTS "Service role all" ON powertrains;
CREATE POLICY "Service role all" ON powertrains FOR ALL USING (auth.role() = 'service_role');
DROP POLICY IF EXISTS "Service role all" ON tco_params;
CREATE POLICY "Service role all" ON tco_params FOR ALL USING (auth.role() = 'service_role');

