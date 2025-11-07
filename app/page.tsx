'use client';

import { useState, useEffect } from 'react';
import { supabase, Brand, Model, Trim, Powertrain } from '@/lib/supabase';

interface CarData {
  brands: Brand[];
  models: Model[];
  trims: Trim[];
  powertrains: Powertrain[];
  tcoParams: Record<string, Record<string, number>>; // fuel_type -> param_type -> value
}

export default function Home() {
  const [carData, setCarData] = useState<CarData>({
    brands: [],
    models: [],
    trims: [],
    powertrains: [],
    tcoParams: {},
  });
  const [loading, setLoading] = useState(true);
  
  const [selectedBrandId, setSelectedBrandId] = useState<number | null>(null);
  const [selectedModelId, setSelectedModelId] = useState<number | null>(null);
  const [selectedTrimId, setSelectedTrimId] = useState<number | null>(null);
  const [selectedPowertrainId, setSelectedPowertrainId] = useState<number | null>(null);
  
  const [inputs, setInputs] = useState({
    annualKm: '15000',
    yearsOwned: '5',
    parkingMonthly: '60',
    tollsMonthly: '25',
  });

  const selectedPowertrain = carData.powertrains.find(p => p.id === selectedPowertrainId);

  // Fetch all data from Supabase
  useEffect(() => {
    const fetchData = async () => {
      try {
        setLoading(true);
        
        // Fetch brands
        const { data: brands, error: brandsError } = await supabase
          .from('brands')
          .select('*')
          .order('name');

        if (brandsError) throw brandsError;

        // Fetch models
        const { data: models, error: modelsError } = await supabase
          .from('models')
          .select('*')
          .order('name');

        if (modelsError) throw modelsError;

        // Fetch trims
        const { data: trims, error: trimsError } = await supabase
          .from('trims')
          .select('*')
          .order('model_year', { ascending: false })
          .order('name');

        if (trimsError) throw trimsError;

        // Fetch powertrains
        const { data: powertrains, error: powertrainsError } = await supabase
          .from('powertrains')
          .select('*')
          .order('name');

        if (powertrainsError) throw powertrainsError;

        // Fetch TCO parameters
        const { data: tcoParams, error: tcoParamsError } = await supabase
          .from('tco_params')
          .select('*')
          .eq('country_code', 'DE')
          .eq('year', 2024);

        if (tcoParamsError) throw tcoParamsError;

        // Organize TCO params by fuel_type and param_type
        const tcoParamsMap: Record<string, Record<string, number>> = {};
        tcoParams?.forEach(param => {
          const fuelType = param.fuel_type || 'default';
          if (!tcoParamsMap[fuelType]) {
            tcoParamsMap[fuelType] = {};
          }
          tcoParamsMap[fuelType][param.param_type] = param.value_eur;
        });

        setCarData({
          brands: brands || [],
          models: models || [],
          trims: trims || [],
          powertrains: powertrains || [],
          tcoParams: tcoParamsMap,
        });
      } catch (error) {
        console.error('Error fetching data from Supabase:', error);
      } finally {
        setLoading(false);
      }
    };

    fetchData();
  }, []);

  const handleInputChange = (field: string, value: string) => {
    setInputs(prev => ({ ...prev, [field]: value }));
  };

  const handleBrandChange = (brandId: string) => {
    const id = brandId ? parseInt(brandId) : null;
    setSelectedBrandId(id);
    setSelectedModelId(null);
    setSelectedTrimId(null);
    setSelectedPowertrainId(null);
  };

  const handleModelChange = (modelId: string) => {
    const id = modelId ? parseInt(modelId) : null;
    setSelectedModelId(id);
    setSelectedTrimId(null);
    setSelectedPowertrainId(null);
  };

  const handleTrimChange = (trimId: string) => {
    const id = trimId ? parseInt(trimId) : null;
    setSelectedTrimId(id);
    setSelectedPowertrainId(null);
  };

  const handlePowertrainChange = (powertrainId: string) => {
    const id = powertrainId ? parseInt(powertrainId) : null;
    setSelectedPowertrainId(id);
  };

  // Filter available options
  const availableModels = selectedBrandId
    ? carData.models.filter(m => m.brand_id === selectedBrandId)
    : [];

  const availableTrims = selectedModelId
    ? carData.trims.filter(t => t.model_id === selectedModelId)
    : [];

  const availablePowertrains = selectedTrimId
    ? carData.powertrains.filter(p => p.trim_id === selectedTrimId)
    : [];

  // Calculations
  const parseFloatSafe = (value: string, fallback: number): number => {
    const parsed = parseFloat(value);
    return isNaN(parsed) ? fallback : parsed;
  };

  const annualKm = parseFloatSafe(inputs.annualKm, 0);
  const yearsOwned = parseFloatSafe(inputs.yearsOwned, 1);
  const parkingMonthly = parseFloatSafe(inputs.parkingMonthly, 0);
  const tollsMonthly = parseFloatSafe(inputs.tollsMonthly, 0);
  const carValue = selectedPowertrain ? selectedPowertrain.msrp_eur : 0;

  // Get TCO parameters for selected powertrain
  const fuelType = selectedPowertrain?.fuel_type || 'petrol';
  const fuelParams = carData.tcoParams[fuelType] || {};
  const defaultParams = carData.tcoParams['petrol'] || {};

  // Fuel/Energy costs
  let fuelAnnual = 0;
  if (selectedPowertrain) {
    if (selectedPowertrain.fuel_type === 'bev') {
      // EV: use kWh/100km and electricity price
      const kwhPer100km = selectedPowertrain.combined_kwh_per_100km || 0;
      const electricityPrice = fuelParams['electricity_price'] || defaultParams['electricity_price'] || 0.35;
      fuelAnnual = (annualKm / 100) * kwhPer100km * electricityPrice;
    } else if (selectedPowertrain.fuel_type === 'phev') {
      // PHEV: assume 50% electric, 50% petrol
      const kwhPer100km = selectedPowertrain.combined_kwh_per_100km || 0;
      const lPer100km = selectedPowertrain.combined_l_per_100km || 0;
      const electricityPrice = fuelParams['electricity_price'] || defaultParams['electricity_price'] || 0.35;
      const fuelPrice = fuelParams['fuel_price'] || defaultParams['fuel_price'] || 1.85;
      const electricCost = (annualKm / 100) * kwhPer100km * electricityPrice * 0.5;
      const petrolCost = (annualKm / 100) * lPer100km * fuelPrice * 0.5;
      fuelAnnual = electricCost + petrolCost;
    } else {
      // ICE/HEV: use L/100km and fuel price
      const lPer100km = selectedPowertrain.combined_l_per_100km || 0;
      const fuelPrice = fuelParams['fuel_price'] || defaultParams['fuel_price'] || 1.85;
      fuelAnnual = (annualKm / 100) * lPer100km * fuelPrice;
    }
  }

  // Insurance
  const insuranceAnnual = fuelParams['insurance_annual'] || defaultParams['insurance_annual'] || 800;

  // Maintenance
  const maintenanceAnnual = fuelParams['maintenance_annual'] || defaultParams['maintenance_annual'] || 600;

  // Tax/Registration
  const taxAnnual = fuelParams['tax_annual'] || defaultParams['tax_annual'] || 180;

  // Depreciation (using residual value percentage)
  const residualValuePct = fuelParams['residual_value_pct_3y'] || 55;
  const depreciationAnnual = carValue > 0 ? (carValue * (1 - residualValuePct / 100)) / yearsOwned : 0;

  // Other costs
  const parkingAnnual = parkingMonthly * 12;
  const tollsAnnual = tollsMonthly * 12;

  const totalAnnual = fuelAnnual + insuranceAnnual + maintenanceAnnual + 
                      depreciationAnnual + taxAnnual + parkingAnnual + tollsAnnual;
  const totalMonthly = totalAnnual / 12;
  const costPerKm = annualKm > 0 ? totalAnnual / annualKm : 0;

  const categories = [
    { name: 'Fuel/Energy', value: fuelAnnual, color: 'bg-blue-500' },
    { name: 'Insurance', value: insuranceAnnual, color: 'bg-green-500' },
    { name: 'Depreciation', value: depreciationAnnual, color: 'bg-purple-500' },
    { name: 'Maintenance', value: maintenanceAnnual, color: 'bg-orange-500' },
    { name: 'Tax/Registration', value: taxAnnual, color: 'bg-pink-500' },
    { name: 'Parking', value: parkingAnnual, color: 'bg-yellow-500' },
    { name: 'Tolls', value: tollsAnnual, color: 'bg-red-500' },
  ];

  const formatCurrency = (value: number) => {
    return new Intl.NumberFormat('de-DE', {
      style: 'currency',
      currency: 'EUR',
      minimumFractionDigits: 0,
      maximumFractionDigits: 0,
    }).format(value);
  };

  if (loading) {
    return (
      <div className="min-h-screen bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-50 dark:from-slate-900 dark:via-slate-800 dark:to-slate-900 flex items-center justify-center">
        <div className="text-center">
          <div className="animate-spin rounded-full h-12 w-12 border-b-2 border-indigo-600 mx-auto mb-4"></div>
          <p className="text-slate-600 dark:text-slate-400">Loading calculator...</p>
        </div>
      </div>
    );
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-50 dark:from-slate-900 dark:via-slate-800 dark:to-slate-900">
      <div className="container mx-auto px-4 py-8 md:py-12 max-w-6xl">
        {/* Header */}
        <div className="text-center mb-8 md:mb-12">
          <h1 className="text-4xl md:text-5xl font-bold bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent mb-3">
            Vehicle TCO Calculator
          </h1>
          <p className="text-slate-600 dark:text-slate-400 text-lg">
            Calculate total cost of ownership using real vehicle data
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Input Section */}
          <div className="lg:col-span-2 space-y-6">
            {/* Car Selection */}
            <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border border-slate-200 dark:border-slate-700">
              <h2 className="text-xl font-semibold mb-4 text-slate-800 dark:text-slate-200 flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-indigo-500"></span>
                Vehicle Selection
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Brand
                  </label>
                  <select
                    value={selectedBrandId || ''}
                    onChange={(e) => handleBrandChange(e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all appearance-none cursor-pointer"
                  >
                    <option value="">Select Brand</option>
                    {carData.brands.map((brand) => (
                      <option key={brand.id} value={brand.id}>
                        {brand.name}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Model
                  </label>
                  <select
                    value={selectedModelId || ''}
                    onChange={(e) => handleModelChange(e.target.value)}
                    disabled={!selectedBrandId}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all appearance-none cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    <option value="">Select Model</option>
                    {availableModels.map((model) => (
                      <option key={model.id} value={model.id}>
                        {model.name}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Trim
                  </label>
                  <select
                    value={selectedTrimId || ''}
                    onChange={(e) => handleTrimChange(e.target.value)}
                    disabled={!selectedModelId}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all appearance-none cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    <option value="">Select Trim</option>
                    {availableTrims.map((trim) => (
                      <option key={trim.id} value={trim.id}>
                        {trim.name} ({trim.model_year})
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Powertrain
                  </label>
                  <select
                    value={selectedPowertrainId || ''}
                    onChange={(e) => handlePowertrainChange(e.target.value)}
                    disabled={!selectedTrimId}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all appearance-none cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    <option value="">Select Powertrain</option>
                    {availablePowertrains.map((powertrain) => (
                      <option key={powertrain.id} value={powertrain.id}>
                        {powertrain.name}
                      </option>
                    ))}
                  </select>
                </div>
              </div>
              {selectedPowertrain && (
                <div className="mt-4 p-4 bg-indigo-50 dark:bg-indigo-900/20 rounded-lg border border-indigo-200 dark:border-indigo-800">
                  <div className="grid grid-cols-2 md:grid-cols-4 gap-3 text-sm">
                    <div>
                      <span className="text-indigo-600 dark:text-indigo-400 font-medium">MSRP:</span>
                      <span className="ml-2 text-indigo-800 dark:text-indigo-200">{formatCurrency(selectedPowertrain.msrp_eur)}</span>
                    </div>
                    <div>
                      <span className="text-indigo-600 dark:text-indigo-400 font-medium">Power:</span>
                      <span className="ml-2 text-indigo-800 dark:text-indigo-200">{selectedPowertrain.power_hp} HP</span>
                    </div>
                    <div>
                      <span className="text-indigo-600 dark:text-indigo-400 font-medium">Fuel Type:</span>
                      <span className="ml-2 text-indigo-800 dark:text-indigo-200 capitalize">{selectedPowertrain.fuel_type}</span>
                    </div>
                    <div>
                      <span className="text-indigo-600 dark:text-indigo-400 font-medium">Consumption:</span>
                      <span className="ml-2 text-indigo-800 dark:text-indigo-200">
                        {selectedPowertrain.combined_l_per_100km 
                          ? `${selectedPowertrain.combined_l_per_100km} L/100km`
                          : selectedPowertrain.combined_kwh_per_100km 
                          ? `${selectedPowertrain.combined_kwh_per_100km} kWh/100km`
                          : 'N/A'}
                      </span>
                    </div>
                  </div>
                </div>
              )}
            </div>

            {/* Usage Parameters */}
            <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border border-slate-200 dark:border-slate-700">
              <h2 className="text-xl font-semibold mb-4 text-slate-800 dark:text-slate-200 flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-blue-500"></span>
                Usage Parameters
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Annual Kilometers
                  </label>
                  <input
                    type="number"
                    value={inputs.annualKm}
                    onChange={(e) => handleInputChange('annualKm', e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                    placeholder="15000"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Years Owned
                  </label>
                  <input
                    type="number"
                    step="0.1"
                    value={inputs.yearsOwned}
                    onChange={(e) => handleInputChange('yearsOwned', e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                    placeholder="5"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Parking/Month (€)
                  </label>
                  <input
                    type="number"
                    step="0.01"
                    value={inputs.parkingMonthly}
                    onChange={(e) => handleInputChange('parkingMonthly', e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                    placeholder="60"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Tolls/Month (€)
                  </label>
                  <input
                    type="number"
                    step="0.01"
                    value={inputs.tollsMonthly}
                    onChange={(e) => handleInputChange('tollsMonthly', e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                    placeholder="25"
                  />
                </div>
              </div>
              {selectedPowertrain && (
                <div className="mt-4 p-3 bg-blue-50 dark:bg-blue-900/20 rounded-lg border border-blue-200 dark:border-blue-800">
                  <p className="text-sm text-blue-800 dark:text-blue-200">
                    <span className="font-semibold">Note:</span> Fuel consumption, insurance, maintenance, and tax rates are automatically calculated based on the selected powertrain and TCO parameters from the database.
                  </p>
                </div>
              )}
            </div>
          </div>

          {/* Results Section */}
          <div className="lg:col-span-1 space-y-6">
            {/* Total Summary */}
            <div className="bg-gradient-to-br from-blue-600 to-indigo-600 rounded-2xl shadow-xl p-6 text-white">
              <h2 className="text-xl font-semibold mb-4">Total Cost</h2>
              <div className="space-y-3">
                <div>
                  <div className="text-sm opacity-90">Annual</div>
                  <div className="text-3xl font-bold">{formatCurrency(totalAnnual)}</div>
                </div>
                <div className="border-t border-white/20 pt-3">
                  <div className="text-sm opacity-90">Monthly</div>
                  <div className="text-2xl font-bold">{formatCurrency(totalMonthly)}</div>
                </div>
                <div className="border-t border-white/20 pt-3">
                  <div className="text-sm opacity-90">Cost per Kilometer</div>
                  <div className="text-xl font-bold">{formatCurrency(costPerKm)}</div>
                </div>
              </div>
            </div>

            {/* Breakdown */}
            <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border border-slate-200 dark:border-slate-700">
              <h2 className="text-xl font-semibold mb-4 text-slate-800 dark:text-slate-200">
                Cost Breakdown
              </h2>
              <div className="space-y-3">
                {categories.map((category) => {
                  const percentage = totalAnnual > 0 ? (category.value / totalAnnual) * 100 : 0;
                  return (
                    <div key={category.name} className="space-y-1">
                      <div className="flex justify-between items-center text-sm">
                        <span className="text-slate-600 dark:text-slate-400">{category.name}</span>
                        <span className="font-semibold text-slate-800 dark:text-slate-200">
                          {formatCurrency(category.value)}
                        </span>
                      </div>
                      <div className="w-full bg-slate-200 dark:bg-slate-700 rounded-full h-2">
                        <div
                          className={`${category.color} h-2 rounded-full transition-all duration-300`}
                          style={{ width: `${percentage}%` }}
                        ></div>
                      </div>
                    </div>
                  );
                })}
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
