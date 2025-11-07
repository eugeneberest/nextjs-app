-- Seed data for MVP
-- Focus: 2024 model year, popular trims/powertrains

-- Brands
INSERT INTO brands (name) VALUES ('Volkswagen'), ('Audi'), ('Hyundai'), ('Volvo')
ON CONFLICT (name) DO NOTHING;

-- Models
INSERT INTO models (brand_id, name, segment)
SELECT id, 'Tiguan', 'C-SUV' FROM brands WHERE name = 'Volkswagen'
ON CONFLICT (brand_id, name) DO NOTHING;

INSERT INTO models (brand_id, name, segment)
SELECT id, 'Q3', 'C-SUV' FROM brands WHERE name = 'Audi'
ON CONFLICT (brand_id, name) DO NOTHING;

INSERT INTO models (brand_id, name, segment)
SELECT id, 'Santa Fe', 'D-SUV' FROM brands WHERE name = 'Hyundai'
ON CONFLICT (brand_id, name) DO NOTHING;

INSERT INTO models (brand_id, name, segment)
SELECT id, 'XC40', 'C-SUV' FROM brands WHERE name = 'Volvo'
ON CONFLICT (brand_id, name) DO NOTHING;

-- Example: VW Tiguan Life 2.0 TDI 150hp 4MOTION DSG (2024)
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Life', 2024
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Volkswagen' AND m.name = 'Tiguan'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    -- If conflict prevented RETURNING, fetch existing id
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Life' AND t2.model_year = 2024 AND b.name = 'Volkswagen' AND m.name = 'Tiguan'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
SELECT 
    et.id,
    '2.0 TDI 150 4MOTION DSG',
    'diesel',
    1968,
    110,
    150,
    'awd',
    '7-speed DSG',
    5.8,
    152,
    42500.00
FROM ensure_trim et
ON CONFLICT (trim_id, name) DO NOTHING;

-- TODO: Add additional verified entries using official WLTP and DE pricing
-- Placeholders for structure (do not insert without official data):
--   - VW Tiguan (e.g., 1.5 TSI DSG FWD)
--   - Audi Q3 (e.g., 35 TFSI S tronic; 35 TDI S tronic)
--   - Hyundai Santa Fe (e.g., Hybrid AWD; Plug-in Hybrid AWD)
--   - Volvo XC40 (e.g., B3/B4 mild hybrid; EX40 single motor BEV)
-- Ensure each row has either combined_l_per_100km OR combined_kwh_per_100km non-null per CHECK constraint,
-- and use exact official WLTP combined values and Germany 2024 MSRP.
