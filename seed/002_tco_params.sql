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
('DE', 'residual_value_pct_3y', 'bev', 45.00, 2024, 'Percentage of purchase price');