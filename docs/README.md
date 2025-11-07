# Vehicle TCO Database - MVP

## Quick Start

### Deploy to Supabase

1. Create a project at supabase.com
2. Run migrations in SQL Editor (or via CLI) in order:

```bash
schema/001_init.sql
schema/002_rls.sql
seed/001_data.sql
seed/002_tco_params.sql
```

3. Test query:

```sql
SELECT 
    b.name as brand,
    m.name as model,
    t.name as trim,
    p.name as powertrain,
    p.fuel_type,
    p.power_hp,
    p.combined_l_per_100km,
    p.combined_kwh_per_100km,
    p.co2_g_per_km,
    p.msrp_eur
FROM brands b
JOIN models m ON m.brand_id = b.id
JOIN trims t ON t.model_id = m.id
JOIN powertrains p ON p.trim_id = t.id
WHERE t.model_year = 2024
ORDER BY b.name, m.name, p.msrp_eur;
```

## Database Schema

5 Core Tables:

- `brands` - Vehicle manufacturers
- `models` - Vehicle models (Tiguan, Q3, etc.)
- `trims` - Trim levels per model/year
- `powertrains` - Engine/powertrain variants with WLTP and pricing
- `tco_params` - Reference data for TCO calculations

## Simple TCO Calculation

```sql
-- 3-year TCO for a powertrain
WITH vehicle AS (
    SELECT * FROM powertrains WHERE id = 123
),
params AS (
    SELECT 
        MAX(CASE WHEN param_type = 'fuel_price' THEN value_eur END) as fuel_price,
        MAX(CASE WHEN param_type = 'insurance_annual' THEN value_eur END) as insurance,
        MAX(CASE WHEN param_type = 'maintenance_annual' THEN value_eur END) as maintenance,
        MAX(CASE WHEN param_type = 'tax_annual' THEN value_eur END) as tax,
        MAX(CASE WHEN param_type = 'residual_value_pct_3y' THEN value_eur END) as residual_pct
    FROM tco_params
    WHERE country_code = 'DE' 
      AND year = 2024
      AND fuel_type = (SELECT fuel_type FROM vehicle)
)
SELECT 
    v.msrp_eur as purchase_price,
    (v.msrp_eur * (1 - p.residual_pct/100)) as depreciation_3y,
    (v.combined_l_per_100km / 100 * 15000 * p.fuel_price * 3) as fuel_cost_3y,
    (p.insurance * 3) as insurance_3y,
    (p.maintenance * 3) as maintenance_3y,
    (p.tax * 3) as tax_3y,
    -- Total
    v.msrp_eur + 
    (v.msrp_eur * (1 - p.residual_pct/100)) +
    (v.combined_l_per_100km / 100 * 15000 * p.fuel_price * 3) +
    (p.insurance * 3) +
    (p.maintenance * 3) +
    (p.tax * 3) as total_tco_3y
FROM vehicle v, params p;
```

## Units

- Distance: km
- Volume: liters (L)
- Energy: kilowatt-hours (kWh)
- Power: kilowatts (kW) and horsepower (HP)
- Fuel consumption: L/100km or kWh/100km
- Price: EUR (€)

## Extending Data

Add new powertrain:

```sql
INSERT INTO powertrains (trim_id, name, fuel_type, ...)
VALUES (...);
```

Update pricing:

```sql
UPDATE tco_params 
SET value_eur = 1.95 
WHERE param_type = 'fuel_price' AND fuel_type = 'petrol';
```

## Data Sources

All data from official sources:

- Manufacturer configurators (VW.de, Audi.de, etc.)
- WLTP certificates
- German market pricing (2024)

See SOURCES.md for complete list.
