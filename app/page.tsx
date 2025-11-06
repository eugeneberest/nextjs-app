'use client';

import { useState } from 'react';

export default function Home() {
  const [inputs, setInputs] = useState({
    // Fuel
    annualMiles: '12000',
    mpg: '25',
    fuelPrice: '3.50',
    
    // Insurance
    insuranceMonthly: '150',
    
    // Maintenance
    maintenanceAnnual: '1000',
    
    // Depreciation
    carValue: '30000',
    yearsOwned: '5',
    
    // Other
    registrationAnnual: '200',
    parkingMonthly: '50',
    tollsMonthly: '30',
  });

  const handleInputChange = (field: string, value: string) => {
    setInputs(prev => ({ ...prev, [field]: value }));
  };

  // Calculations
  const parseFloatSafe = (value: string, fallback: number): number => {
    const parsed = parseFloat(value);
    return isNaN(parsed) ? fallback : parsed;
  };

  const annualMiles = parseFloatSafe(inputs.annualMiles, 0);
  const mpg = parseFloatSafe(inputs.mpg, 1);
  const fuelPrice = parseFloatSafe(inputs.fuelPrice, 0);
  const insuranceMonthly = parseFloatSafe(inputs.insuranceMonthly, 0);
  const maintenanceAnnual = parseFloatSafe(inputs.maintenanceAnnual, 0);
  const carValue = parseFloatSafe(inputs.carValue, 0);
  const yearsOwned = parseFloatSafe(inputs.yearsOwned, 1);
  const registrationAnnual = parseFloatSafe(inputs.registrationAnnual, 0);
  const parkingMonthly = parseFloatSafe(inputs.parkingMonthly, 0);
  const tollsMonthly = parseFloatSafe(inputs.tollsMonthly, 0);

  const fuelAnnual = (annualMiles / mpg) * fuelPrice;
  const insuranceAnnual = insuranceMonthly * 12;
  const depreciationAnnual = carValue / yearsOwned;
  const parkingAnnual = parkingMonthly * 12;
  const tollsAnnual = tollsMonthly * 12;

  const totalAnnual = fuelAnnual + insuranceAnnual + maintenanceAnnual + 
                      depreciationAnnual + registrationAnnual + parkingAnnual + tollsAnnual;
  const totalMonthly = totalAnnual / 12;
  const costPerMile = annualMiles > 0 ? totalAnnual / annualMiles : 0;

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
    return new Intl.NumberFormat('en-US', {
      style: 'currency',
      currency: 'USD',
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
            {/* Fuel Costs */}
            <div className="bg-white dark:bg-slate-800 rounded-2xl shadow-lg p-6 border border-slate-200 dark:border-slate-700">
              <h2 className="text-xl font-semibold mb-4 text-slate-800 dark:text-slate-200 flex items-center gap-2">
                <span className="w-2 h-2 rounded-full bg-blue-500"></span>
                Fuel Costs
              </h2>
              <div className="grid grid-cols-1 md:grid-cols-3 gap-4">
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Annual Miles
                  </label>
                  <input
                    type="number"
                    value={inputs.annualMiles}
                    onChange={(e) => handleInputChange('annualMiles', e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                    placeholder="12000"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    MPG
                  </label>
                  <input
                    type="number"
                    value={inputs.mpg}
                    onChange={(e) => handleInputChange('mpg', e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                    placeholder="25"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Fuel Price ($/gallon)
                  </label>
                  <input
                    type="number"
                    step="0.01"
                    value={inputs.fuelPrice}
                    onChange={(e) => handleInputChange('fuelPrice', e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-blue-500 focus:border-transparent transition-all"
                    placeholder="3.50"
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
                  Monthly Premium ($)
                </label>
                <input
                  type="number"
                  step="0.01"
                  value={inputs.insuranceMonthly}
                  onChange={(e) => handleInputChange('insuranceMonthly', e.target.value)}
                  className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-green-500 focus:border-transparent transition-all"
                  placeholder="150"
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
                  Annual Maintenance ($)
                </label>
                <input
                  type="number"
                  step="0.01"
                  value={inputs.maintenanceAnnual}
                  onChange={(e) => handleInputChange('maintenanceAnnual', e.target.value)}
                  className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-orange-500 focus:border-transparent transition-all"
                  placeholder="1000"
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
                    Car Value ($)
                  </label>
                  <input
                    type="number"
                    value={inputs.carValue}
                    onChange={(e) => handleInputChange('carValue', e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-purple-500 focus:border-transparent transition-all"
                    placeholder="30000"
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
                    Registration/Annual ($)
                  </label>
                  <input
                    type="number"
                    step="0.01"
                    value={inputs.registrationAnnual}
                    onChange={(e) => handleInputChange('registrationAnnual', e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-pink-500 focus:border-transparent transition-all"
                    placeholder="200"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Parking/Month ($)
                  </label>
                  <input
                    type="number"
                    step="0.01"
                    value={inputs.parkingMonthly}
                    onChange={(e) => handleInputChange('parkingMonthly', e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-yellow-500 focus:border-transparent transition-all"
                    placeholder="50"
                  />
                </div>
                <div>
                  <label className="block text-sm font-medium text-slate-600 dark:text-slate-400 mb-2">
                    Tolls/Month ($)
                  </label>
                  <input
                    type="number"
                    step="0.01"
                    value={inputs.tollsMonthly}
                    onChange={(e) => handleInputChange('tollsMonthly', e.target.value)}
                    className="w-full px-4 py-2.5 rounded-lg border border-slate-300 dark:border-slate-600 bg-white dark:bg-slate-700 text-slate-900 dark:text-slate-100 focus:ring-2 focus:ring-red-500 focus:border-transparent transition-all"
                    placeholder="30"
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
                  <div className="text-sm opacity-90">Cost per Mile</div>
                  <div className="text-xl font-bold">{formatCurrency(costPerMile)}</div>
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
