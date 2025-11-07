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

-- ============================================
-- VW TIGUAN - Multiple Trims and Powertrains
-- ============================================

-- Tiguan Elegance 2024
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Elegance', 2024
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Volkswagen' AND m.name = 'Tiguan'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Elegance' AND t2.model_year = 2024 AND b.name = 'Volkswagen' AND m.name = 'Tiguan'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
SELECT 
    et.id,
    '1.5 TSI 150 DSG',
    'petrol',
    1498,
    110,
    150,
    'fwd',
    '7-speed DSG',
    6.2,
    141,
    38900.00
FROM ensure_trim et
ON CONFLICT (trim_id, name) DO NOTHING;

-- Tiguan R-Line 2024
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'R-Line', 2024
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Volkswagen' AND m.name = 'Tiguan'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'R-Line' AND t2.model_year = 2024 AND b.name = 'Volkswagen' AND m.name = 'Tiguan'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), '2.0 TSI 245 4MOTION DSG', 'petrol', 1984, 180, 245, 'awd', '7-speed DSG', 7.8, 177, 48900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), '2.0 TDI 200 4MOTION DSG', 'diesel', 1968, 147, 200, 'awd', '7-speed DSG', 6.1, 160, 46900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- Add more powertrain to existing Life trim
WITH ensure_trim AS (
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
    '1.5 TSI 150 DSG',
    'petrol',
    1498,
    110,
    150,
    'fwd',
    '7-speed DSG',
    6.2,
    141,
    36500.00
FROM ensure_trim et
ON CONFLICT (trim_id, name) DO NOTHING;

-- ============================================
-- AUDI Q3 - Multiple Trims and Powertrains
-- ============================================

-- Q3 Advanced 2024
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Advanced', 2024
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Audi' AND m.name = 'Q3'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Advanced' AND t2.model_year = 2024 AND b.name = 'Audi' AND m.name = 'Q3'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), '35 TFSI S tronic', 'petrol', 1395, 110, 150, 'fwd', '7-speed S tronic', 6.5, 148, 41900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), '35 TDI S tronic', 'diesel', 1968, 110, 150, 'fwd', '7-speed S tronic', 5.3, 139, 42900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- Q3 S line 2024
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'S line', 2024
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Audi' AND m.name = 'Q3'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'S line' AND t2.model_year = 2024 AND b.name = 'Audi' AND m.name = 'Q3'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), '45 TFSI quattro S tronic', 'petrol', 1984, 169, 230, 'awd', '7-speed S tronic', 7.9, 180, 49900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), '45 TDI quattro S tronic', 'diesel', 1968, 169, 230, 'awd', '7-speed S tronic', 6.4, 168, 51900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- ============================================
-- HYUNDAI SANTA FE - Multiple Trims and Powertrains
-- ============================================

-- Santa Fe Premium 2024
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Premium', 2024
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Hyundai' AND m.name = 'Santa Fe'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Premium' AND t2.model_year = 2024 AND b.name = 'Hyundai' AND m.name = 'Santa Fe'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), '2.2 CRDi 8AT AWD', 'diesel', 2199, 147, 200, 'awd', '8-speed automatic', 6.8, 179, 44900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- Santa Fe Ultimate 2024
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Ultimate', 2024
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Hyundai' AND m.name = 'Santa Fe'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Ultimate' AND t2.model_year = 2024 AND b.name = 'Hyundai' AND m.name = 'Santa Fe'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), 'Hybrid 8AT AWD', 'hev', 1999, 169, 230, 'awd', '8-speed automatic', 6.2, 142, 49900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), 'Plug-in Hybrid 6AT AWD', 'phev', 1999, 200, 272, 'awd', '6-speed automatic', 1.4, 32, 56900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- Note: PHEV uses combined_l_per_100km (petrol consumption) which satisfies the CHECK constraint

-- ============================================
-- VOLVO XC40 - Multiple Trims and Powertrains
-- ============================================

-- XC40 Core 2024
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Core', 2024
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Volvo' AND m.name = 'XC40'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Core' AND t2.model_year = 2024 AND b.name = 'Volvo' AND m.name = 'XC40'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), 'B3 Mild Hybrid AWD', 'petrol', 1969, 120, 163, 'awd', '8-speed automatic', 7.2, 164, 42900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), 'B4 Mild Hybrid AWD', 'petrol', 1969, 145, 197, 'awd', '8-speed automatic', 7.5, 171, 45900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- XC40 Plus 2024
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Plus', 2024
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Volvo' AND m.name = 'XC40'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Plus' AND t2.model_year = 2024 AND b.name = 'Volvo' AND m.name = 'XC40'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_kwh_per_100km, co2_g_per_km, battery_usable_kwh, wltp_range_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), 'EX40 Single Motor', 'bev', NULL, 175, 238, 'fwd', 'Single-speed', 18.5, 0, 69.0, 460, 54900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), 'EX40 Twin Motor', 'bev', NULL, 300, 408, 'awd', 'Single-speed', 20.8, 0, 78.0, 425, 59900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- XC40 Ultimate 2024
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Ultimate', 2024
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Volvo' AND m.name = 'XC40'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Ultimate' AND t2.model_year = 2024 AND b.name = 'Volvo' AND m.name = 'XC40'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), 'B5 Mild Hybrid AWD', 'petrol', 1969, 184, 250, 'awd', '8-speed automatic', 7.8, 178, 51900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- ============================================
-- 2022 MODEL YEAR DATA
-- ============================================

-- ============================================
-- VW TIGUAN 2022 - Multiple Trims and Powertrains
-- ============================================

-- Tiguan Trendline 2022
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Trendline', 2022
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Volkswagen' AND m.name = 'Tiguan'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Trendline' AND t2.model_year = 2022 AND b.name = 'Volkswagen' AND m.name = 'Tiguan'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), '1.4 TSI 150 DSG', 'petrol', 1395, 110, 150, 'fwd', '6-speed DSG', 6.5, 148, 33900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), '2.0 TDI 150 DSG', 'diesel', 1968, 110, 150, 'fwd', '7-speed DSG', 5.9, 155, 34900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- Tiguan Comfortline 2022
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Comfortline', 2022
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Volkswagen' AND m.name = 'Tiguan'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Comfortline' AND t2.model_year = 2022 AND b.name = 'Volkswagen' AND m.name = 'Tiguan'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), '1.5 TSI 150 DSG', 'petrol', 1498, 110, 150, 'fwd', '7-speed DSG', 6.3, 144, 36900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), '2.0 TDI 150 4MOTION DSG', 'diesel', 1968, 110, 150, 'awd', '7-speed DSG', 6.0, 158, 39900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), '2.0 TSI 180 4MOTION DSG', 'petrol', 1984, 132, 180, 'awd', '7-speed DSG', 7.2, 164, 41900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- Tiguan Highline 2022
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Highline', 2022
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Volkswagen' AND m.name = 'Tiguan'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Highline' AND t2.model_year = 2022 AND b.name = 'Volkswagen' AND m.name = 'Tiguan'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), '2.0 TSI 220 4MOTION DSG', 'petrol', 1984, 162, 220, 'awd', '7-speed DSG', 7.6, 173, 44900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), '2.0 TDI 190 4MOTION DSG', 'diesel', 1968, 140, 190, 'awd', '7-speed DSG', 6.2, 163, 45900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- Tiguan R-Line 2022
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'R-Line', 2022
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Volkswagen' AND m.name = 'Tiguan'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'R-Line' AND t2.model_year = 2022 AND b.name = 'Volkswagen' AND m.name = 'Tiguan'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), '2.0 TSI 245 4MOTION DSG', 'petrol', 1984, 180, 245, 'awd', '7-speed DSG', 8.0, 182, 47900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), '2.0 TDI 200 4MOTION DSG', 'diesel', 1968, 147, 200, 'awd', '7-speed DSG', 6.3, 165, 46900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- ============================================
-- AUDI Q3 2022 - Multiple Trims and Powertrains
-- ============================================

-- Q3 2022
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Base', 2022
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Audi' AND m.name = 'Q3'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Base' AND t2.model_year = 2022 AND b.name = 'Audi' AND m.name = 'Q3'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), '35 TFSI S tronic', 'petrol', 1395, 110, 150, 'fwd', '7-speed S tronic', 6.6, 150, 38900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), '35 TDI S tronic', 'diesel', 1968, 110, 150, 'fwd', '7-speed S tronic', 5.4, 142, 39900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- Q3 Advanced 2022
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Advanced', 2022
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Audi' AND m.name = 'Q3'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Advanced' AND t2.model_year = 2022 AND b.name = 'Audi' AND m.name = 'Q3'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), '40 TFSI quattro S tronic', 'petrol', 1984, 132, 180, 'awd', '7-speed S tronic', 7.3, 166, 44900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), '40 TDI quattro S tronic', 'diesel', 1968, 140, 190, 'awd', '7-speed S tronic', 6.1, 160, 45900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- Q3 S line 2022
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'S line', 2022
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Audi' AND m.name = 'Q3'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'S line' AND t2.model_year = 2022 AND b.name = 'Audi' AND m.name = 'Q3'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), '45 TFSI quattro S tronic', 'petrol', 1984, 169, 230, 'awd', '7-speed S tronic', 8.1, 184, 48900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), '45 TDI quattro S tronic', 'diesel', 1968, 169, 230, 'awd', '7-speed S tronic', 6.5, 171, 49900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- ============================================
-- HYUNDAI SANTA FE 2022 - Multiple Trims and Powertrains
-- ============================================

-- Santa Fe Comfort 2022
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Comfort', 2022
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Hyundai' AND m.name = 'Santa Fe'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Comfort' AND t2.model_year = 2022 AND b.name = 'Hyundai' AND m.name = 'Santa Fe'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), '2.2 CRDi 8AT AWD', 'diesel', 2199, 147, 200, 'awd', '8-speed automatic', 7.0, 184, 41900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- Santa Fe Premium 2022
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Premium', 2022
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Hyundai' AND m.name = 'Santa Fe'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Premium' AND t2.model_year = 2022 AND b.name = 'Hyundai' AND m.name = 'Santa Fe'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), '2.2 CRDi 8AT AWD', 'diesel', 2199, 147, 200, 'awd', '8-speed automatic', 7.0, 184, 43900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), 'Hybrid 8AT AWD', 'hev', 1999, 169, 230, 'awd', '8-speed automatic', 6.4, 147, 46900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- Santa Fe Ultimate 2022
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Ultimate', 2022
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Hyundai' AND m.name = 'Santa Fe'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Ultimate' AND t2.model_year = 2022 AND b.name = 'Hyundai' AND m.name = 'Santa Fe'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), 'Hybrid 8AT AWD', 'hev', 1999, 169, 230, 'awd', '8-speed automatic', 6.4, 147, 48900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), 'Plug-in Hybrid 6AT AWD', 'phev', 1999, 200, 272, 'awd', '6-speed automatic', 1.5, 35, 54900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- ============================================
-- VOLVO XC40 2022 - Multiple Trims and Powertrains
-- ============================================

-- XC40 Momentum 2022
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Momentum', 2022
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Volvo' AND m.name = 'XC40'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Momentum' AND t2.model_year = 2022 AND b.name = 'Volvo' AND m.name = 'XC40'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), 'T3 FWD', 'petrol', 1477, 120, 163, 'fwd', '8-speed automatic', 7.0, 159, 38900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), 'T4 AWD', 'petrol', 1969, 140, 190, 'awd', '8-speed automatic', 7.4, 168, 41900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), 'D3 FWD', 'diesel', 1969, 110, 150, 'fwd', '8-speed automatic', 5.2, 137, 39900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- XC40 R-Design 2022
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'R-Design', 2022
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Volvo' AND m.name = 'XC40'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'R-Design' AND t2.model_year = 2022 AND b.name = 'Volvo' AND m.name = 'XC40'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_l_per_100km, co2_g_per_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), 'T4 AWD', 'petrol', 1969, 140, 190, 'awd', '8-speed automatic', 7.4, 168, 44900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), 'T5 AWD', 'petrol', 1969, 184, 250, 'awd', '8-speed automatic', 7.9, 180, 47900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), 'D4 AWD', 'diesel', 1969, 140, 190, 'awd', '8-speed automatic', 5.6, 147, 45900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- XC40 Inscription 2022
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Inscription', 2022
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Volvo' AND m.name = 'XC40'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Inscription' AND t2.model_year = 2022 AND b.name = 'Volvo' AND m.name = 'XC40'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_kwh_per_100km, co2_g_per_km, battery_usable_kwh, wltp_range_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), 'P8 AWD Recharge', 'bev', NULL, 300, 408, 'awd', 'Single-speed', 21.2, 0, 78.0, 418, 56900.00)
ON CONFLICT (trim_id, name) DO NOTHING;

-- XC40 Recharge 2022 (BEV trim)
WITH trim AS (
    INSERT INTO trims (model_id, name, model_year)
    SELECT m.id, 'Recharge', 2022
    FROM models m 
    JOIN brands b ON m.brand_id = b.id
    WHERE b.name = 'Volvo' AND m.name = 'XC40'
    ON CONFLICT (model_id, name, model_year) DO NOTHING
    RETURNING id
),
ensure_trim AS (
    SELECT id FROM trim
    UNION ALL
    SELECT t2.id FROM trims t2
    JOIN models m ON m.id = t2.model_id
    JOIN brands b ON b.id = m.brand_id
    WHERE t2.name = 'Recharge' AND t2.model_year = 2022 AND b.name = 'Volvo' AND m.name = 'XC40'
    LIMIT 1
)
INSERT INTO powertrains (
    trim_id, name, fuel_type, displacement_cc, power_kw, power_hp,
    drivetrain, transmission,
    combined_kwh_per_100km, co2_g_per_km, battery_usable_kwh, wltp_range_km, msrp_eur
)
VALUES
    ((SELECT id FROM ensure_trim LIMIT 1), 'P8 AWD Single Motor', 'bev', NULL, 175, 238, 'fwd', 'Single-speed', 19.0, 0, 69.0, 418, 51900.00),
    ((SELECT id FROM ensure_trim LIMIT 1), 'P8 AWD Twin Motor', 'bev', NULL, 300, 408, 'awd', 'Single-speed', 21.2, 0, 78.0, 418, 58900.00)
ON CONFLICT (trim_id, name) DO NOTHING;
