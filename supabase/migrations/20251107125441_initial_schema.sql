-- Create car_brands table
CREATE TABLE IF NOT EXISTS car_brands (
  id BIGSERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL UNIQUE,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW())
);

-- Create car_models table
CREATE TABLE IF NOT EXISTS car_models (
  id BIGSERIAL PRIMARY KEY,
  brand_id BIGINT NOT NULL REFERENCES car_brands(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  UNIQUE(brand_id, name)
);

-- Create car_modifications table
CREATE TABLE IF NOT EXISTS car_modifications (
  id BIGSERIAL PRIMARY KEY,
  model_id BIGINT NOT NULL REFERENCES car_models(id) ON DELETE CASCADE,
  name VARCHAR(100) NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT TIMEZONE('utc', NOW()),
  UNIQUE(model_id, name)
);

-- Create indexes for better query performance
CREATE INDEX IF NOT EXISTS idx_car_models_brand_id ON car_models(brand_id);
CREATE INDEX IF NOT EXISTS idx_car_modifications_model_id ON car_modifications(model_id);

-- Enable Row Level Security (RLS)
ALTER TABLE car_brands ENABLE ROW LEVEL SECURITY;
ALTER TABLE car_models ENABLE ROW LEVEL SECURITY;
ALTER TABLE car_modifications ENABLE ROW LEVEL SECURITY;

-- Create policies to allow public read access
CREATE POLICY "Allow public read access on car_brands"
  ON car_brands FOR SELECT
  USING (true);

CREATE POLICY "Allow public read access on car_models"
  ON car_models FOR SELECT
  USING (true);

CREATE POLICY "Allow public read access on car_modifications"
  ON car_modifications FOR SELECT
  USING (true);

-- Insert sample data (European car brands and models)
-- Brands
INSERT INTO car_brands (name) VALUES
  ('Volkswagen'),
  ('BMW'),
  ('Mercedes-Benz'),
  ('Audi'),
  ('Peugeot'),
  ('Renault'),
  ('Ford'),
  ('Opel'),
  ('Skoda'),
  ('SEAT')
ON CONFLICT (name) DO NOTHING;

-- Volkswagen Models
INSERT INTO car_models (brand_id, name)
SELECT id, 'Golf' FROM car_brands WHERE name = 'Volkswagen'
UNION ALL
SELECT id, 'Passat' FROM car_brands WHERE name = 'Volkswagen'
UNION ALL
SELECT id, 'Polo' FROM car_brands WHERE name = 'Volkswagen'
UNION ALL
SELECT id, 'Tiguan' FROM car_brands WHERE name = 'Volkswagen'
UNION ALL
SELECT id, 'ID.3' FROM car_brands WHERE name = 'Volkswagen'
UNION ALL
SELECT id, 'ID.4' FROM car_brands WHERE name = 'Volkswagen'
ON CONFLICT (brand_id, name) DO NOTHING;

-- BMW Models
INSERT INTO car_models (brand_id, name)
SELECT id, '3 Series' FROM car_brands WHERE name = 'BMW'
UNION ALL
SELECT id, '5 Series' FROM car_brands WHERE name = 'BMW'
UNION ALL
SELECT id, 'X3' FROM car_brands WHERE name = 'BMW'
UNION ALL
SELECT id, 'X5' FROM car_brands WHERE name = 'BMW'
UNION ALL
SELECT id, 'i4' FROM car_brands WHERE name = 'BMW'
UNION ALL
SELECT id, 'iX3' FROM car_brands WHERE name = 'BMW'
ON CONFLICT (brand_id, name) DO NOTHING;

-- Mercedes-Benz Models
INSERT INTO car_models (brand_id, name)
SELECT id, 'C-Class' FROM car_brands WHERE name = 'Mercedes-Benz'
UNION ALL
SELECT id, 'E-Class' FROM car_brands WHERE name = 'Mercedes-Benz'
UNION ALL
SELECT id, 'GLC' FROM car_brands WHERE name = 'Mercedes-Benz'
UNION ALL
SELECT id, 'GLE' FROM car_brands WHERE name = 'Mercedes-Benz'
UNION ALL
SELECT id, 'EQC' FROM car_brands WHERE name = 'Mercedes-Benz'
UNION ALL
SELECT id, 'EQS' FROM car_brands WHERE name = 'Mercedes-Benz'
ON CONFLICT (brand_id, name) DO NOTHING;

-- Audi Models
INSERT INTO car_models (brand_id, name)
SELECT id, 'A3' FROM car_brands WHERE name = 'Audi'
UNION ALL
SELECT id, 'A4' FROM car_brands WHERE name = 'Audi'
UNION ALL
SELECT id, 'A6' FROM car_brands WHERE name = 'Audi'
UNION ALL
SELECT id, 'Q5' FROM car_brands WHERE name = 'Audi'
UNION ALL
SELECT id, 'Q7' FROM car_brands WHERE name = 'Audi'
UNION ALL
SELECT id, 'e-tron' FROM car_brands WHERE name = 'Audi'
ON CONFLICT (brand_id, name) DO NOTHING;

-- Peugeot Models
INSERT INTO car_models (brand_id, name)
SELECT id, '208' FROM car_brands WHERE name = 'Peugeot'
UNION ALL
SELECT id, '308' FROM car_brands WHERE name = 'Peugeot'
UNION ALL
SELECT id, '3008' FROM car_brands WHERE name = 'Peugeot'
UNION ALL
SELECT id, '5008' FROM car_brands WHERE name = 'Peugeot'
ON CONFLICT (brand_id, name) DO NOTHING;

-- Renault Models
INSERT INTO car_models (brand_id, name)
SELECT id, 'Clio' FROM car_brands WHERE name = 'Renault'
UNION ALL
SELECT id, 'Megane' FROM car_brands WHERE name = 'Renault'
UNION ALL
SELECT id, 'Captur' FROM car_brands WHERE name = 'Renault'
UNION ALL
SELECT id, 'Zoe' FROM car_brands WHERE name = 'Renault'
ON CONFLICT (brand_id, name) DO NOTHING;

-- Ford Models
INSERT INTO car_models (brand_id, name)
SELECT id, 'Fiesta' FROM car_brands WHERE name = 'Ford'
UNION ALL
SELECT id, 'Focus' FROM car_brands WHERE name = 'Ford'
UNION ALL
SELECT id, 'Kuga' FROM car_brands WHERE name = 'Ford'
UNION ALL
SELECT id, 'Mustang Mach-E' FROM car_brands WHERE name = 'Ford'
ON CONFLICT (brand_id, name) DO NOTHING;

-- Opel Models
INSERT INTO car_models (brand_id, name)
SELECT id, 'Corsa' FROM car_brands WHERE name = 'Opel'
UNION ALL
SELECT id, 'Astra' FROM car_brands WHERE name = 'Opel'
UNION ALL
SELECT id, 'Mokka' FROM car_brands WHERE name = 'Opel'
UNION ALL
SELECT id, 'Grandland' FROM car_brands WHERE name = 'Opel'
ON CONFLICT (brand_id, name) DO NOTHING;

-- Skoda Models
INSERT INTO car_models (brand_id, name)
SELECT id, 'Octavia' FROM car_brands WHERE name = 'Skoda'
UNION ALL
SELECT id, 'Superb' FROM car_brands WHERE name = 'Skoda'
UNION ALL
SELECT id, 'Kodiaq' FROM car_brands WHERE name = 'Skoda'
UNION ALL
SELECT id, 'Enyaq' FROM car_brands WHERE name = 'Skoda'
ON CONFLICT (brand_id, name) DO NOTHING;

-- SEAT Models
INSERT INTO car_models (brand_id, name)
SELECT id, 'Ibiza' FROM car_brands WHERE name = 'SEAT'
UNION ALL
SELECT id, 'Leon' FROM car_brands WHERE name = 'SEAT'
UNION ALL
SELECT id, 'Ateca' FROM car_brands WHERE name = 'SEAT'
UNION ALL
SELECT id, 'Born' FROM car_brands WHERE name = 'SEAT'
ON CONFLICT (brand_id, name) DO NOTHING;

-- Volkswagen Golf Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.0 TSI' FROM car_models WHERE name = 'Golf' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
UNION ALL
SELECT id, '1.5 TSI' FROM car_models WHERE name = 'Golf' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
UNION ALL
SELECT id, '2.0 TDI' FROM car_models WHERE name = 'Golf' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
UNION ALL
SELECT id, 'GTE' FROM car_models WHERE name = 'Golf' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
UNION ALL
SELECT id, 'R' FROM car_models WHERE name = 'Golf' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
ON CONFLICT (model_id, name) DO NOTHING;

-- Volkswagen Passat Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.5 TSI' FROM car_models WHERE name = 'Passat' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
UNION ALL
SELECT id, '2.0 TSI' FROM car_models WHERE name = 'Passat' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
UNION ALL
SELECT id, '2.0 TDI' FROM car_models WHERE name = 'Passat' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
UNION ALL
SELECT id, 'GTE' FROM car_models WHERE name = 'Passat' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
ON CONFLICT (model_id, name) DO NOTHING;

-- Volkswagen Polo Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.0 TSI' FROM car_models WHERE name = 'Polo' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
UNION ALL
SELECT id, '1.5 TSI' FROM car_models WHERE name = 'Polo' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
UNION ALL
SELECT id, '2.0 TDI' FROM car_models WHERE name = 'Polo' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
ON CONFLICT (model_id, name) DO NOTHING;

-- Volkswagen Tiguan Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.5 TSI' FROM car_models WHERE name = 'Tiguan' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
UNION ALL
SELECT id, '2.0 TSI' FROM car_models WHERE name = 'Tiguan' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
UNION ALL
SELECT id, '2.0 TDI' FROM car_models WHERE name = 'Tiguan' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
UNION ALL
SELECT id, 'R' FROM car_models WHERE name = 'Tiguan' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
ON CONFLICT (model_id, name) DO NOTHING;

-- Volkswagen ID.3 Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'Pure' FROM car_models WHERE name = 'ID.3' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
UNION ALL
SELECT id, 'Pro' FROM car_models WHERE name = 'ID.3' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
UNION ALL
SELECT id, 'Pro S' FROM car_models WHERE name = 'ID.3' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
ON CONFLICT (model_id, name) DO NOTHING;

-- Volkswagen ID.4 Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'Pure' FROM car_models WHERE name = 'ID.4' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
UNION ALL
SELECT id, 'Pro' FROM car_models WHERE name = 'ID.4' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
UNION ALL
SELECT id, 'GTX' FROM car_models WHERE name = 'ID.4' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Volkswagen')
ON CONFLICT (model_id, name) DO NOTHING;

-- BMW 3 Series Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '318i' FROM car_models WHERE name = '3 Series' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
UNION ALL
SELECT id, '320i' FROM car_models WHERE name = '3 Series' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
UNION ALL
SELECT id, '330i' FROM car_models WHERE name = '3 Series' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
UNION ALL
SELECT id, '320d' FROM car_models WHERE name = '3 Series' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
UNION ALL
SELECT id, '330d' FROM car_models WHERE name = '3 Series' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
UNION ALL
SELECT id, 'M3' FROM car_models WHERE name = '3 Series' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
ON CONFLICT (model_id, name) DO NOTHING;

-- BMW 5 Series Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '520i' FROM car_models WHERE name = '5 Series' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
UNION ALL
SELECT id, '530i' FROM car_models WHERE name = '5 Series' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
UNION ALL
SELECT id, '530d' FROM car_models WHERE name = '5 Series' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
UNION ALL
SELECT id, '540i' FROM car_models WHERE name = '5 Series' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
UNION ALL
SELECT id, 'M5' FROM car_models WHERE name = '5 Series' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
ON CONFLICT (model_id, name) DO NOTHING;

-- BMW X3 Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'xDrive20i' FROM car_models WHERE name = 'X3' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
UNION ALL
SELECT id, 'xDrive30i' FROM car_models WHERE name = 'X3' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
UNION ALL
SELECT id, 'xDrive30d' FROM car_models WHERE name = 'X3' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
UNION ALL
SELECT id, 'M40i' FROM car_models WHERE name = 'X3' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
ON CONFLICT (model_id, name) DO NOTHING;

-- BMW X5 Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'xDrive30d' FROM car_models WHERE name = 'X5' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
UNION ALL
SELECT id, 'xDrive40i' FROM car_models WHERE name = 'X5' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
UNION ALL
SELECT id, 'xDrive50i' FROM car_models WHERE name = 'X5' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
UNION ALL
SELECT id, 'M50i' FROM car_models WHERE name = 'X5' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
ON CONFLICT (model_id, name) DO NOTHING;

-- BMW i4 Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'eDrive40' FROM car_models WHERE name = 'i4' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
UNION ALL
SELECT id, 'M50' FROM car_models WHERE name = 'i4' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
ON CONFLICT (model_id, name) DO NOTHING;

-- BMW iX3 Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'eDrive' FROM car_models WHERE name = 'iX3' AND brand_id = (SELECT id FROM car_brands WHERE name = 'BMW')
ON CONFLICT (model_id, name) DO NOTHING;

-- Mercedes-Benz C-Class Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'C 180' FROM car_models WHERE name = 'C-Class' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
UNION ALL
SELECT id, 'C 200' FROM car_models WHERE name = 'C-Class' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
UNION ALL
SELECT id, 'C 220 d' FROM car_models WHERE name = 'C-Class' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
UNION ALL
SELECT id, 'C 300' FROM car_models WHERE name = 'C-Class' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
UNION ALL
SELECT id, 'AMG C 43' FROM car_models WHERE name = 'C-Class' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
ON CONFLICT (model_id, name) DO NOTHING;

-- Mercedes-Benz E-Class Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'E 200' FROM car_models WHERE name = 'E-Class' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
UNION ALL
SELECT id, 'E 220 d' FROM car_models WHERE name = 'E-Class' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
UNION ALL
SELECT id, 'E 300' FROM car_models WHERE name = 'E-Class' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
UNION ALL
SELECT id, 'E 350 e' FROM car_models WHERE name = 'E-Class' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
UNION ALL
SELECT id, 'AMG E 53' FROM car_models WHERE name = 'E-Class' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
ON CONFLICT (model_id, name) DO NOTHING;

-- Mercedes-Benz GLC Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'GLC 200' FROM car_models WHERE name = 'GLC' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
UNION ALL
SELECT id, 'GLC 220 d' FROM car_models WHERE name = 'GLC' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
UNION ALL
SELECT id, 'GLC 300' FROM car_models WHERE name = 'GLC' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
UNION ALL
SELECT id, 'AMG GLC 43' FROM car_models WHERE name = 'GLC' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
ON CONFLICT (model_id, name) DO NOTHING;

-- Mercedes-Benz GLE Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'GLE 300 d' FROM car_models WHERE name = 'GLE' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
UNION ALL
SELECT id, 'GLE 350' FROM car_models WHERE name = 'GLE' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
UNION ALL
SELECT id, 'GLE 450' FROM car_models WHERE name = 'GLE' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
UNION ALL
SELECT id, 'AMG GLE 53' FROM car_models WHERE name = 'GLE' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
ON CONFLICT (model_id, name) DO NOTHING;

-- Mercedes-Benz EQC Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'EQC 400' FROM car_models WHERE name = 'EQC' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
ON CONFLICT (model_id, name) DO NOTHING;

-- Mercedes-Benz EQS Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'EQS 450+' FROM car_models WHERE name = 'EQS' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
UNION ALL
SELECT id, 'EQS 580' FROM car_models WHERE name = 'EQS' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Mercedes-Benz')
ON CONFLICT (model_id, name) DO NOTHING;

-- Audi A3 Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '30 TFSI' FROM car_models WHERE name = 'A3' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, '35 TFSI' FROM car_models WHERE name = 'A3' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, '40 TFSI' FROM car_models WHERE name = 'A3' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, '35 TDI' FROM car_models WHERE name = 'A3' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, 'S3' FROM car_models WHERE name = 'A3' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
ON CONFLICT (model_id, name) DO NOTHING;

-- Audi A4 Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '35 TDI' FROM car_models WHERE name = 'A4' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, '40 TFSI' FROM car_models WHERE name = 'A4' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, '45 TFSI' FROM car_models WHERE name = 'A4' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, 'S4' FROM car_models WHERE name = 'A4' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
ON CONFLICT (model_id, name) DO NOTHING;

-- Audi A6 Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '40 TDI' FROM car_models WHERE name = 'A6' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, '45 TFSI' FROM car_models WHERE name = 'A6' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, '50 TDI' FROM car_models WHERE name = 'A6' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, 'S6' FROM car_models WHERE name = 'A6' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
ON CONFLICT (model_id, name) DO NOTHING;

-- Audi Q5 Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '40 TDI' FROM car_models WHERE name = 'Q5' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, '45 TFSI' FROM car_models WHERE name = 'Q5' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, '50 TDI' FROM car_models WHERE name = 'Q5' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, 'SQ5' FROM car_models WHERE name = 'Q5' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
ON CONFLICT (model_id, name) DO NOTHING;

-- Audi Q7 Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '45 TDI' FROM car_models WHERE name = 'Q7' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, '50 TDI' FROM car_models WHERE name = 'Q7' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, '55 TFSI' FROM car_models WHERE name = 'Q7' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, 'SQ7' FROM car_models WHERE name = 'Q7' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
ON CONFLICT (model_id, name) DO NOTHING;

-- Audi e-tron Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '50' FROM car_models WHERE name = 'e-tron' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, '55' FROM car_models WHERE name = 'e-tron' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
UNION ALL
SELECT id, 'S' FROM car_models WHERE name = 'e-tron' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Audi')
ON CONFLICT (model_id, name) DO NOTHING;

-- Peugeot 208 Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.2 PureTech' FROM car_models WHERE name = '208' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Peugeot')
UNION ALL
SELECT id, 'e-208' FROM car_models WHERE name = '208' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Peugeot')
ON CONFLICT (model_id, name) DO NOTHING;

-- Peugeot 308 Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.2 PureTech' FROM car_models WHERE name = '308' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Peugeot')
UNION ALL
SELECT id, '1.5 BlueHDi' FROM car_models WHERE name = '308' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Peugeot')
UNION ALL
SELECT id, 'e-308' FROM car_models WHERE name = '308' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Peugeot')
ON CONFLICT (model_id, name) DO NOTHING;

-- Peugeot 3008 Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.2 PureTech' FROM car_models WHERE name = '3008' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Peugeot')
UNION ALL
SELECT id, '1.6 Hybrid' FROM car_models WHERE name = '3008' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Peugeot')
UNION ALL
SELECT id, 'PHEV' FROM car_models WHERE name = '3008' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Peugeot')
ON CONFLICT (model_id, name) DO NOTHING;

-- Peugeot 5008 Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.2 PureTech' FROM car_models WHERE name = '5008' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Peugeot')
UNION ALL
SELECT id, '1.6 Hybrid' FROM car_models WHERE name = '5008' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Peugeot')
UNION ALL
SELECT id, 'PHEV' FROM car_models WHERE name = '5008' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Peugeot')
ON CONFLICT (model_id, name) DO NOTHING;

-- Renault Clio Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'TCe 100' FROM car_models WHERE name = 'Clio' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Renault')
UNION ALL
SELECT id, 'TCe 130' FROM car_models WHERE name = 'Clio' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Renault')
UNION ALL
SELECT id, 'E-Tech' FROM car_models WHERE name = 'Clio' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Renault')
ON CONFLICT (model_id, name) DO NOTHING;

-- Renault Megane Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'TCe 140' FROM car_models WHERE name = 'Megane' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Renault')
UNION ALL
SELECT id, 'TCe 205' FROM car_models WHERE name = 'Megane' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Renault')
UNION ALL
SELECT id, 'E-Tech' FROM car_models WHERE name = 'Megane' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Renault')
ON CONFLICT (model_id, name) DO NOTHING;

-- Renault Captur Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'TCe 140' FROM car_models WHERE name = 'Captur' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Renault')
UNION ALL
SELECT id, 'E-Tech' FROM car_models WHERE name = 'Captur' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Renault')
ON CONFLICT (model_id, name) DO NOTHING;

-- Renault Zoe Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'R110' FROM car_models WHERE name = 'Zoe' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Renault')
UNION ALL
SELECT id, 'R135' FROM car_models WHERE name = 'Zoe' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Renault')
ON CONFLICT (model_id, name) DO NOTHING;

-- Ford Fiesta Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.0 EcoBoost' FROM car_models WHERE name = 'Fiesta' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Ford')
UNION ALL
SELECT id, 'ST' FROM car_models WHERE name = 'Fiesta' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Ford')
ON CONFLICT (model_id, name) DO NOTHING;

-- Ford Focus Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.0 EcoBoost' FROM car_models WHERE name = 'Focus' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Ford')
UNION ALL
SELECT id, '1.5 EcoBoost' FROM car_models WHERE name = 'Focus' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Ford')
UNION ALL
SELECT id, '2.0 TDCi' FROM car_models WHERE name = 'Focus' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Ford')
UNION ALL
SELECT id, 'ST' FROM car_models WHERE name = 'Focus' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Ford')
ON CONFLICT (model_id, name) DO NOTHING;

-- Ford Kuga Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.5 EcoBoost' FROM car_models WHERE name = 'Kuga' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Ford')
UNION ALL
SELECT id, '2.0 TDCi' FROM car_models WHERE name = 'Kuga' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Ford')
UNION ALL
SELECT id, 'PHEV' FROM car_models WHERE name = 'Kuga' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Ford')
ON CONFLICT (model_id, name) DO NOTHING;

-- Ford Mustang Mach-E Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'Select' FROM car_models WHERE name = 'Mustang Mach-E' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Ford')
UNION ALL
SELECT id, 'Premium' FROM car_models WHERE name = 'Mustang Mach-E' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Ford')
UNION ALL
SELECT id, 'GT' FROM car_models WHERE name = 'Mustang Mach-E' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Ford')
ON CONFLICT (model_id, name) DO NOTHING;

-- Opel Corsa Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.2' FROM car_models WHERE name = 'Corsa' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Opel')
UNION ALL
SELECT id, '1.4 Turbo' FROM car_models WHERE name = 'Corsa' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Opel')
UNION ALL
SELECT id, 'e-Corsa' FROM car_models WHERE name = 'Corsa' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Opel')
ON CONFLICT (model_id, name) DO NOTHING;

-- Opel Astra Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.2 Turbo' FROM car_models WHERE name = 'Astra' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Opel')
UNION ALL
SELECT id, '1.4 Turbo' FROM car_models WHERE name = 'Astra' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Opel')
UNION ALL
SELECT id, '1.6 CDTI' FROM car_models WHERE name = 'Astra' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Opel')
ON CONFLICT (model_id, name) DO NOTHING;

-- Opel Mokka Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.2 Turbo' FROM car_models WHERE name = 'Mokka' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Opel')
UNION ALL
SELECT id, 'e-Mokka' FROM car_models WHERE name = 'Mokka' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Opel')
ON CONFLICT (model_id, name) DO NOTHING;

-- Opel Grandland Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.2 Turbo' FROM car_models WHERE name = 'Grandland' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Opel')
UNION ALL
SELECT id, '1.6 Hybrid' FROM car_models WHERE name = 'Grandland' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Opel')
UNION ALL
SELECT id, 'PHEV' FROM car_models WHERE name = 'Grandland' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Opel')
ON CONFLICT (model_id, name) DO NOTHING;

-- Skoda Octavia Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.0 TSI' FROM car_models WHERE name = 'Octavia' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Skoda')
UNION ALL
SELECT id, '1.5 TSI' FROM car_models WHERE name = 'Octavia' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Skoda')
UNION ALL
SELECT id, '2.0 TDI' FROM car_models WHERE name = 'Octavia' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Skoda')
UNION ALL
SELECT id, 'vRS' FROM car_models WHERE name = 'Octavia' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Skoda')
ON CONFLICT (model_id, name) DO NOTHING;

-- Skoda Superb Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.5 TSI' FROM car_models WHERE name = 'Superb' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Skoda')
UNION ALL
SELECT id, '2.0 TSI' FROM car_models WHERE name = 'Superb' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Skoda')
UNION ALL
SELECT id, '2.0 TDI' FROM car_models WHERE name = 'Superb' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Skoda')
ON CONFLICT (model_id, name) DO NOTHING;

-- Skoda Kodiaq Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.5 TSI' FROM car_models WHERE name = 'Kodiaq' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Skoda')
UNION ALL
SELECT id, '2.0 TSI' FROM car_models WHERE name = 'Kodiaq' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Skoda')
UNION ALL
SELECT id, '2.0 TDI' FROM car_models WHERE name = 'Kodiaq' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Skoda')
UNION ALL
SELECT id, 'vRS' FROM car_models WHERE name = 'Kodiaq' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Skoda')
ON CONFLICT (model_id, name) DO NOTHING;

-- Skoda Enyaq Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '60' FROM car_models WHERE name = 'Enyaq' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Skoda')
UNION ALL
SELECT id, '80' FROM car_models WHERE name = 'Enyaq' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Skoda')
UNION ALL
SELECT id, 'vRS' FROM car_models WHERE name = 'Enyaq' AND brand_id = (SELECT id FROM car_brands WHERE name = 'Skoda')
ON CONFLICT (model_id, name) DO NOTHING;

-- SEAT Ibiza Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.0 TSI' FROM car_models WHERE name = 'Ibiza' AND brand_id = (SELECT id FROM car_brands WHERE name = 'SEAT')
UNION ALL
SELECT id, '1.5 TSI' FROM car_models WHERE name = 'Ibiza' AND brand_id = (SELECT id FROM car_brands WHERE name = 'SEAT')
UNION ALL
SELECT id, 'FR' FROM car_models WHERE name = 'Ibiza' AND brand_id = (SELECT id FROM car_brands WHERE name = 'SEAT')
ON CONFLICT (model_id, name) DO NOTHING;

-- SEAT Leon Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.0 TSI' FROM car_models WHERE name = 'Leon' AND brand_id = (SELECT id FROM car_brands WHERE name = 'SEAT')
UNION ALL
SELECT id, '1.5 TSI' FROM car_models WHERE name = 'Leon' AND brand_id = (SELECT id FROM car_brands WHERE name = 'SEAT')
UNION ALL
SELECT id, '2.0 TDI' FROM car_models WHERE name = 'Leon' AND brand_id = (SELECT id FROM car_brands WHERE name = 'SEAT')
UNION ALL
SELECT id, 'Cupra' FROM car_models WHERE name = 'Leon' AND brand_id = (SELECT id FROM car_brands WHERE name = 'SEAT')
ON CONFLICT (model_id, name) DO NOTHING;

-- SEAT Ateca Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, '1.5 TSI' FROM car_models WHERE name = 'Ateca' AND brand_id = (SELECT id FROM car_brands WHERE name = 'SEAT')
UNION ALL
SELECT id, '2.0 TSI' FROM car_models WHERE name = 'Ateca' AND brand_id = (SELECT id FROM car_brands WHERE name = 'SEAT')
UNION ALL
SELECT id, 'Cupra' FROM car_models WHERE name = 'Ateca' AND brand_id = (SELECT id FROM car_brands WHERE name = 'SEAT')
ON CONFLICT (model_id, name) DO NOTHING;

-- SEAT Born Modifications
INSERT INTO car_modifications (model_id, name)
SELECT id, 'e-Boost' FROM car_models WHERE name = 'Born' AND brand_id = (SELECT id FROM car_brands WHERE name = 'SEAT')
UNION ALL
SELECT id, 'e-Boost 150' FROM car_models WHERE name = 'Born' AND brand_id = (SELECT id FROM car_brands WHERE name = 'SEAT')
UNION ALL
SELECT id, 'e-Boost 230' FROM car_models WHERE name = 'Born' AND brand_id = (SELECT id FROM car_brands WHERE name = 'SEAT')
ON CONFLICT (model_id, name) DO NOTHING;

