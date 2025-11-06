'use client';

import { useState, useEffect } from 'react';
import { supabase, CarBrand, CarModel, CarModification } from '@/lib/supabase';

// Fallback database in case Supabase is not configured
const fallbackDatabase: Record<string, Record<string, string[]>> = {
  'Volkswagen': {
    'Golf': ['1.0 TSI', '1.5 TSI', '2.0 TDI', 'GTE', 'R'],
    'Passat': ['1.5 TSI', '2.0 TSI', '2.0 TDI', 'GTE'],
    'Polo': ['1.0 TSI', '1.5 TSI', '2.0 TDI'],
    'Tiguan': ['1.5 TSI', '2.0 TSI', '2.0 TDI', 'R'],
    'ID.3': ['Pure', 'Pro', 'Pro S'],
    'ID.4': ['Pure', 'Pro', 'GTX'],
  },
  'BMW': {
    '3 Series': ['318i', '320i', '330i', '320d', '330d', 'M3'],
    '5 Series': ['520i', '530i', '530d', '540i', 'M5'],
    'X3': ['xDrive20i', 'xDrive30i', 'xDrive30d', 'M40i'],
    'X5': ['xDrive30d', 'xDrive40i', 'xDrive50i', 'M50i'],
    'i4': ['eDrive40', 'M50'],
    'iX3': ['eDrive'],
  },
  'Mercedes-Benz': {
    'C-Class': ['C 180', 'C 200', 'C 220 d', 'C 300', 'AMG C 43'],
    'E-Class': ['E 200', 'E 220 d', 'E 300', 'E 350 e', 'AMG E 53'],
    'GLC': ['GLC 200', 'GLC 220 d', 'GLC 300', 'AMG GLC 43'],
    'GLE': ['GLE 300 d', 'GLE 350', 'GLE 450', 'AMG GLE 53'],
    'EQC': ['EQC 400'],
    'EQS': ['EQS 450+', 'EQS 580'],
  },
  'Audi': {
    'A3': ['30 TFSI', '35 TFSI', '40 TFSI', '35 TDI', 'S3'],
    'A4': ['35 TDI', '40 TFSI', '45 TFSI', 'S4'],
    'A6': ['40 TDI', '45 TFSI', '50 TDI', 'S6'],
    'Q5': ['40 TDI', '45 TFSI', '50 TDI', 'SQ5'],
    'Q7': ['45 TDI', '50 TDI', '55 TFSI', 'SQ7'],
    'e-tron': ['50', '55', 'S'],
  },
  'Peugeot': {
    '208': ['1.2 PureTech', 'e-208'],
    '308': ['1.2 PureTech', '1.5 BlueHDi', 'e-308'],
    '3008': ['1.2 PureTech', '1.6 Hybrid', 'PHEV'],
    '5008': ['1.2 PureTech', '1.6 Hybrid', 'PHEV'],
  },
  'Renault': {
    'Clio': ['TCe 100', 'TCe 130', 'E-Tech'],
    'Megane': ['TCe 140', 'TCe 205', 'E-Tech'],
    'Captur': ['TCe 140', 'E-Tech'],
    'Zoe': ['R110', 'R135'],
  },
  'Ford': {
    'Fiesta': ['1.0 EcoBoost', 'ST'],
    'Focus': ['1.0 EcoBoost', '1.5 EcoBoost', '2.0 TDCi', 'ST'],
    'Kuga': ['1.5 EcoBoost', '2.0 TDCi', 'PHEV'],
    'Mustang Mach-E': ['Select', 'Premium', 'GT'],
  },
  'Opel': {
    'Corsa': ['1.2', '1.4 Turbo', 'e-Corsa'],
    'Astra': ['1.2 Turbo', '1.4 Turbo', '1.6 CDTI'],
    'Mokka': ['1.2 Turbo', 'e-Mokka'],
    'Grandland': ['1.2 Turbo', '1.6 Hybrid', 'PHEV'],
  },
  'Skoda': {
    'Octavia': ['1.0 TSI', '1.5 TSI', '2.0 TDI', 'vRS'],
    'Superb': ['1.5 TSI', '2.0 TSI', '2.0 TDI'],
    'Kodiaq': ['1.5 TSI', '2.0 TSI', '2.0 TDI', 'vRS'],
    'Enyaq': ['60', '80', 'vRS'],
  },
  'SEAT': {
    'Ibiza': ['1.0 TSI', '1.5 TSI', 'FR'],
    'Leon': ['1.0 TSI', '1.5 TSI', '2.0 TDI', 'Cupra'],
    'Ateca': ['1.5 TSI', '2.0 TSI', 'Cupra'],
    'Born': ['e-Boost', 'e-Boost 150', 'e-Boost 230'],
  },
};

export default function Home() {
  const [selectedBrand, setSelectedBrand] = useState<string>('');
  const [selectedModel, setSelectedModel] = useState<string>('');
  const [selectedModification, setSelectedModification] = useState<string>('');
  const [carDatabase, setCarDatabase] = useState<Record<string, Record<string, string[]>>>(fallbackDatabase);
  const [brands, setBrands] = useState<CarBrand[]>([]);
  const [loading, setLoading] = useState(true);

  const [inputs, setInputs] = useState({
    // Fuel
    annualKm: '15000',
    litersPer100km: '7.5',
    fuelPrice: '1.80',
    
    // Insurance
    insuranceMonthly: '120',
    
    // Maintenance
    maintenanceAnnual: '800',
    
    // Depreciation
    carValue: '25000',
    yearsOwned: '5',
    
    // Other
    registrationAnnual: '300',
    parkingMonthly: '60',
    tollsMonthly: '25',
  });

  const handleInputChange = (field: string, value: string) => {
    setInputs(prev => ({ ...prev, [field]: value }));
  };

  const handleBrandChange = (brand: string) => {
    setSelectedBrand(brand);
    setSelectedModel('');
    setSelectedModification('');
  };

  const handleModelChange = (model: string) => {
    setSelectedModel(model);
    setSelectedModification('');
  };

  // Fetch car data from Supabase
  useEffect(() => {
    const fetchCarData = async () => {
      try {
        // Fetch brands
        const { data: brandsData, error: brandsError } = await supabase
          .from('car_brands')
          .select('*')
          .order('name');

        if (brandsError) throw brandsError;

        if (brandsData && brandsData.length > 0) {
          setBrands(brandsData);

          // Fetch all models
          const { data: modelsData, error: modelsError } = await supabase
            .from('car_models')
            .select('*')
            .order('name');

          if (modelsError) throw modelsError;

          // Fetch all modifications
          const { data: modificationsData, error: modificationsError } = await supabase
            .from('car_modifications')
            .select('*')
            .order('name');

          if (modificationsError) throw modificationsError;

          // Build the car database structure
          const db: Record<string, Record<string, string[]>> = {};
          
          brandsData.forEach((brand) => {
            db[brand.name] = {};
            const brandModels = modelsData?.filter(m => m.brand_id === brand.id) || [];
            
            brandModels.forEach((model) => {
              const modelModifications = modificationsData?.filter(m => m.model_id === model.id) || [];
              db[brand.name][model.name] = modelModifications.map(mod => mod.name);
            });
          });

          setCarDatabase(db);
        }
      } catch (error) {
        console.error('Error fetching car data from Supabase:', error);
        // Use fallback database if Supabase fails
        setCarDatabase(fallbackDatabase);
      } finally {
        setLoading(false);
      }
    };

    fetchCarData();
  }, []);

  const availableModels = selectedBrand ? Object.keys(carDatabase[selectedBrand] || {}) : [];
  const availableModifications = selectedBrand && selectedModel 
    ? (carDatabase[selectedBrand]?.[selectedModel] || []) 
    : [];

  // Calculations
  const parseFloatSafe = (value: string, fallback: number): number => {
    const parsed = parseFloat(value);
    return isNaN(parsed) ? fallback : parsed;
  };

  const annualKm = parseFloatSafe(inputs.annualKm, 0);
  const litersPer100km = parseFloatSafe(inputs.litersPer100km, 1);
  const fuelPrice = parseFloatSafe(inputs.fuelPrice, 0);
  const insuranceMonthly = parseFloatSafe(inputs.insuranceMonthly, 0);
  const maintenanceAnnual = parseFloatSafe(inputs.maintenanceAnnual, 0);
  const carValue = parseFloatSafe(inputs.carValue, 0);
  const yearsOwned = parseFloatSafe(inputs.yearsOwned, 1);
  const registrationAnnual = parseFloatSafe(inputs.registrationAnnual, 0);
  const parkingMonthly = parseFloatSafe(inputs.parkingMonthly, 0);
  const tollsMonthly = parseFloatSafe(inputs.tollsMonthly, 0);

  // Fuel calculation: (annualKm / 100) * litersPer100km * fuelPricePerLiter
  const fuelAnnual = (annualKm / 100) * litersPer100km * fuelPrice;
  const insuranceAnnual = insuranceMonthly * 12;
  const depreciationAnnual = carValue / yearsOwned;
  const parkingAnnual = parkingMonthly * 12;
  const tollsAnnual = tollsMonthly * 12;

  const totalAnnual = fuelAnnual + insuranceAnnual + maintenanceAnnual + 
                      depreciationAnnual + registrationAnnual + parkingAnnual + tollsAnnual;
  const totalMonthly = totalAnnual / 12;
  const costPerKm = annualKm > 0 ? totalAnnual / annualKm : 0;

  const categories = [
    { name: 'Fuel', value: fuelAnnual, color: 'bg-blue-500' },
    { name: 'Insurance', value: insuranceAnnual, color: 'bg-green-500' },
    { name: 'Depreciation', value: depreciationAnnual, color: 'bg-purple-500' },
    { name: 'Maintenance', value: maintenanceAnnual, color: 'bg-orange-500' },
    { name: 'Registration', value: registrationAnnual, color: 'bg-pink-500' },
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

  return (
    <div className="min-h-screen bg-gradient-to-br from-slate-50 via-blue-50 to-indigo-50 dark:from-slate-900 dark:via-slate-800 dark:to-slate-900">
      <div className="container mx-auto px-4 py-8 md:py-12 max-w-6xl">
        {/* Header */}
        <div className="text-center mb-8 md:mb-12">
          <h1 className="text-4xl md:text-5xl font-bold bg-gradient-to-r from-blue-600 to-indigo-600 bg-clip-text text-transparent mb-3">
            Car Ownership Cost Calculator
          </h1>
          <p className="text-slate-600 dark:text-slate-400 text-lg">
            Estimate your annual and monthly car ownership expenses
          </p>
        </div>

        <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
          {/* Input Section */}
          <div className="lg:col-span-2 space-y-6">
            {/* Car Selection */}
            <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border border-slate-200 dark:border-slate-700">
              <h2 className="text-xl font-semibold mb-4 text-slate-800 dark:text-slate-200 flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-indigo-500"></span>
                Car Selection
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Brand
                  </label>
                  <select
                    value={selectedBrand}
                    onChange={(e) => handleBrandChange(e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all appearance-none cursor-pointer"
                  >
                    <option value="">Select Brand</option>
                    {Object.keys(carDatabase).map((brand) => (
                      <option key={brand} value={brand}>
                        {brand}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Model
                  </label>
                  <select
                    value={selectedModel}
                    onChange={(e) => handleModelChange(e.target.value)}
                    disabled={!selectedBrand}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all appearance-none cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    <option value="">Select Model</option>
                    {availableModels.map((model) => (
                      <option key={model} value={model}>
                        {model}
                      </option>
                    ))}
                  </select>
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Modification
                  </label>
                  <select
                    value={selectedModification}
                    onChange={(e) => setSelectedModification(e.target.value)}
                    disabled={!selectedModel}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-indigo-500 focus:border-transparent transition-all appearance-none cursor-pointer disabled:opacity-50 disabled:cursor-not-allowed"
                  >
                    <option value="">Select Modification</option>
                    {availableModifications.map((mod) => (
                      <option key={mod} value={mod}>
                        {mod}
                      </option>
                    ))}
                  </select>
                </div>
              </div>
              {selectedBrand && selectedModel && selectedModification && (
                <div className="mt-4 p-3 bg-indigo-50 dark:bg-indigo-900/20 rounded-lg border border-indigo-200 dark:border-indigo-800">
                  <p className="text-sm text-indigo-800 dark:text-indigo-200">
                    <span className="font-semibold">Selected:</span> {selectedBrand} {selectedModel} {selectedModification}
                  </p>
                </div>
              )}
            </div>

            {/* Fuel Costs */}
            <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border border-slate-200 dark:border-slate-700">
              <h2 className="text-xl font-semibold mb-4 text-slate-800 dark:text-slate-200 flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-blue-500"></span>
                Fuel Costs
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
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
                    L/100km
                  </label>
                  <input
                    type="number"
                    step="0.1"
                    value={inputs.litersPer100km}
                    onChange={(e) => handleInputChange('litersPer100km', e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                    placeholder="7.5"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Fuel Price (€/liter)
                  </label>
                  <input
                    type="number"
                    step="0.01"
                    value={inputs.fuelPrice}
                    onChange={(e) => handleInputChange('fuelPrice', e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                    placeholder="1.80"
                  />
                </div>
              </div>
            </div>

            {/* Insurance */}
            <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border border-slate-200 dark:border-slate-700">
              <h2 className="text-xl font-semibold mb-4 text-slate-800 dark:text-slate-200 flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-green-500"></span>
                Insurance
              </h2>
              <div>
                <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                  Monthly Premium (€)
                </label>
                <input
                  type="number"
                  step="0.01"
                  value={inputs.insuranceMonthly}
                  onChange={(e) => handleInputChange('insuranceMonthly', e.target.value)}
                  className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-green-500 focus:border-transparent transition-all"
                  placeholder="120"
                />
              </div>
            </div>

            {/* Maintenance */}
            <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border border-slate-200 dark:border-slate-700">
              <h2 className="text-xl font-semibold mb-4 text-slate-800 dark:text-slate-200 flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-orange-500"></span>
                Maintenance & Repairs
              </h2>
              <div>
                <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                  Annual Maintenance (€)
                </label>
                <input
                  type="number"
                  step="0.01"
                  value={inputs.maintenanceAnnual}
                  onChange={(e) => handleInputChange('maintenanceAnnual', e.target.value)}
                  className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-orange-500 focus:border-transparent transition-all"
                  placeholder="800"
                />
              </div>
            </div>

            {/* Depreciation */}
            <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border border-slate-200 dark:border-slate-700">
              <h2 className="text-xl font-semibold mb-4 text-slate-800 dark:text-slate-200 flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-purple-500"></span>
                Depreciation
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Car Value (€)
                  </label>
                  <input
                    type="number"
                    value={inputs.carValue}
                    onChange={(e) => handleInputChange('carValue', e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all"
                    placeholder="25000"
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
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all"
                    placeholder="5"
                  />
                </div>
              </div>
            </div>

            {/* Other Costs */}
            <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border border-slate-200 dark:border-slate-700">
              <h2 className="text-xl font-semibold mb-4 text-slate-800 dark:text-slate-200 flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-pink-500"></span>
                Other Costs
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Registration/Annual (€)
                  </label>
                  <input
                    type="number"
                    step="0.01"
                    value={inputs.registrationAnnual}
                    onChange={(e) => handleInputChange('registrationAnnual', e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
                    placeholder="300"
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
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-yellow-500 focus:border-transparent transition-all"
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
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-red-500 focus:border-transparent transition-all"
                    placeholder="25"
                  />
                </div>
              </div>
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
