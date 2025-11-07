-- 5 core tables for MVP TCO database

-- brands
CREATE TABLE IF NOT EXISTS brands (
    id SERIAL PRIMARY KEY,
    name TEXT UNIQUE NOT NULL
);

-- models
CREATE TABLE IF NOT EXISTS models (
    id SERIAL PRIMARY KEY,
    brand_id INT NOT NULL REFERENCES brands(id),
    name TEXT NOT NULL,
    segment TEXT NOT NULL,
    UNIQUE(brand_id, name)
);
CREATE INDEX IF NOT EXISTS idx_models_brand ON models(brand_id);

-- trims
CREATE TABLE IF NOT EXISTS trims (
    id SERIAL PRIMARY KEY,
    model_id INT NOT NULL REFERENCES models(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    model_year INT NOT NULL CHECK (model_year >= 2020),
    UNIQUE(model_id, name, model_year)
);
CREATE INDEX IF NOT EXISTS idx_trims_model ON trims(model_id);

-- powertrains
CREATE TABLE IF NOT EXISTS powertrains (
    id SERIAL PRIMARY KEY,
    trim_id INT NOT NULL REFERENCES trims(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    fuel_type TEXT NOT NULL CHECK (fuel_type IN ('petrol', 'diesel', 'hev', 'phev', 'bev')),
    displacement_cc INT NULL,
    power_kw INT NOT NULL,
    power_hp INT NOT NULL,
    drivetrain TEXT NOT NULL CHECK (drivetrain IN ('fwd', 'awd', 'rwd')),
    transmission TEXT NOT NULL,

    -- WLTP data (embedded for simplicity)
    combined_l_per_100km NUMERIC(4,2) NULL,
    combined_kwh_per_100km NUMERIC(5,2) NULL,
    co2_g_per_km INT NULL,

    -- EV specific
    battery_usable_kwh NUMERIC(5,2) NULL,
    wltp_range_km INT NULL,

    -- Pricing (embedded for MVP)
    msrp_eur NUMERIC(10,2) NOT NULL,

    UNIQUE(trim_id, name),
    CHECK (
        (combined_l_per_100km IS NOT NULL) OR 
        (combined_kwh_per_100km IS NOT NULL)
    )
);
CREATE INDEX IF NOT EXISTS idx_powertrains_trim ON powertrains(trim_id);
CREATE INDEX IF NOT EXISTS idx_powertrains_fuel ON powertrains(fuel_type);

-- tco_params
CREATE TABLE IF NOT EXISTS tco_params (
    id SERIAL PRIMARY KEY,
    country_code CHAR(2) NOT NULL DEFAULT 'DE',
    param_type TEXT NOT NULL,
    fuel_type TEXT NULL,
    value_eur NUMERIC(10,2) NOT NULL,
    year INT NOT NULL,
    notes TEXT NULL,
    UNIQUE(country_code, param_type, fuel_type, year)
);
CREATE INDEX IF NOT EXISTS idx_tco_params_lookup ON tco_params(country_code, param_type, year);
COMMENT ON TABLE tco_params IS 'Reference values for TCO calculations: fuel prices, insurance, maintenance, taxes';