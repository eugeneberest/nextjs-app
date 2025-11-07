import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || 'https://placeholder.supabase.co';
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || 'placeholder-key';

if (!process.env.NEXT_PUBLIC_SUPABASE_URL || !process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY) {
  // Only warn in development, not during build
  if (process.env.NODE_ENV === 'development') {
    console.warn('Supabase environment variables are not set. Please add NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY to your .env.local file');
  }
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

// Types for the database
export interface Brand {
  id: number;
  name: string;
  created_at?: string;
}

export interface Model {
  id: number;
  brand_id: number;
  name: string;
  segment: string;
  created_at?: string;
}

export interface Trim {
  id: number;
  model_id: number;
  name: string;
  model_year: number;
  created_at?: string;
}

export interface Powertrain {
  id: number;
  trim_id: number;
  name: string;
  fuel_type: 'petrol' | 'diesel' | 'hev' | 'phev' | 'bev';
  displacement_cc: number | null;
  power_kw: number;
  power_hp: number;
  drivetrain: 'fwd' | 'awd' | 'rwd';
  transmission: string;
  combined_l_per_100km: number | null;
  combined_kwh_per_100km: number | null;
  co2_g_per_km: number | null;
  battery_usable_kwh: number | null;
  wltp_range_km: number | null;
  msrp_eur: number;
  created_at?: string;
}

export interface TcoParam {
  id: number;
  country_code: string;
  param_type: string;
  fuel_type: string | null;
  value_eur: number;
  year: number;
  notes: string | null;
  created_at?: string;
}

