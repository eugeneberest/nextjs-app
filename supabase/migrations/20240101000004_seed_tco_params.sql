-- Germany 2024 reference values for TCO calculations
INSERT INTO tco_params (country_code, param_type, fuel_type, value_eur, year, notes) VALUES
-- Fuel prices (Germany, 2024 average)
('DE', 'fuel_price', 'petrol', 1.85, 2024, 'EUR per liter, 2024 avg'),
('DE', 'fuel_price', 'diesel', 1.75, 2024, 'EUR per liter, 2024 avg'),
('DE', 'electricity_price', 'bev', 0.35, 2024, 'EUR per kWh, home charging'),
('DE', 'electricity_price_public', 'bev', 0.55, 2024, 'EUR per kWh, public DC fast'),

-- Estimated annual costs (simplified)
('DE', 'insurance_annual', 'petrol', 800.00, 2024, 'Average C-SUV, comprehensive'),
('DE', 'insurance_annual', 'diesel', 850.00, 2024, 'Average C-SUV, comprehensive'),
('DE', 'insurance_annual', 'bev', 900.00, 2024, 'Average C-SUV, comprehensive'),
('DE', 'maintenance_annual', 'petrol', 600.00, 2024, 'Average service costs'),
('DE', 'maintenance_annual', 'diesel', 700.00, 2024, 'Average service costs'),
('DE', 'maintenance_annual', 'bev', 300.00, 2024, 'Average service costs (lower for EV)'),
('DE', 'tax_annual', 'petrol', 180.00, 2024, 'Road tax (avg for segment)'),
('DE', 'tax_annual', 'diesel', 250.00, 2024, 'Road tax (avg for segment)'),
('DE', 'tax_annual', 'bev', 0.00, 2024, 'EV exemption until 2025'),

-- Depreciation (simplified - 3 year residual value)
('DE', 'residual_value_pct_3y', 'petrol', 55.00, 2024, 'Percentage of purchase price'),
('DE', 'residual_value_pct_3y', 'diesel', 52.00, 2024, 'Percentage of purchase price'),
('DE', 'residual_value_pct_3y', 'bev', 45.00, 2024, 'Percentage of purchase price'),
('DE', 'residual_value_pct_3y', 'hev', 53.00, 2024, 'Percentage of purchase price'),
('DE', 'residual_value_pct_3y', 'phev', 50.00, 2024, 'Percentage of purchase price'),

-- HEV (Hybrid) parameters
('DE', 'fuel_price', 'hev', 1.85, 2024, 'EUR per liter petrol, 2024 avg'),
('DE', 'insurance_annual', 'hev', 850.00, 2024, 'Average C/D-SUV, comprehensive'),
('DE', 'maintenance_annual', 'hev', 550.00, 2024, 'Average service costs (slightly lower than ICE)'),
('DE', 'tax_annual', 'hev', 150.00, 2024, 'Road tax (reduced for hybrid)'),

-- PHEV (Plug-in Hybrid) parameters
('DE', 'fuel_price', 'phev', 1.85, 2024, 'EUR per liter petrol, 2024 avg'),
('DE', 'electricity_price', 'phev', 0.35, 2024, 'EUR per kWh, home charging'),
('DE', 'insurance_annual', 'phev', 900.00, 2024, 'Average C/D-SUV, comprehensive'),
('DE', 'maintenance_annual', 'phev', 500.00, 2024, 'Average service costs (lower than ICE)'),
('DE', 'tax_annual', 'phev', 100.00, 2024, 'Road tax (reduced for PHEV)')
ON CONFLICT (country_code, param_type, fuel_type, year) DO NOTHING;
