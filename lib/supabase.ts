import { createClient } from '@supabase/supabase-js';

const supabaseUrl = process.env.NEXT_PUBLIC_SUPABASE_URL || '';
const supabaseAnonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY || '';

if (!supabaseUrl || !supabaseAnonKey) {
  console.warn('Supabase environment variables are not set. Please add NEXT_PUBLIC_SUPABASE_URL and NEXT_PUBLIC_SUPABASE_ANON_KEY to your .env.local file');
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);

// Types for the database
export interface CarBrand {
  id: number;
  name: string;
  created_at?: string;
}

export interface CarModel {
  id: number;
  brand_id: number;
  name: string;
  created_at?: string;
}

export interface CarModification {
  id: number;
  model_id: number;
  name: string;
  created_at?: string;
}

