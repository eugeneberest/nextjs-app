# Supabase Setup Guide

This guide will help you set up Supabase for the Car Ownership Cost Calculator.

## Step 1: Create a Supabase Project

1. Go to [https://supabase.com](https://supabase.com)
2. Sign up or log in
3. Click "New Project"
4. Fill in your project details:
   - Name: `car-cost-calculator` (or any name you prefer)
   - Database Password: Choose a strong password (save it!)
   - Region: Choose the closest region to your users
5. Click "Create new project" and wait for it to be ready (takes a few minutes)

## Step 2: Get Your API Credentials

1. In your Supabase project dashboard, go to **Settings** → **API**
2. Copy the following values:
   - **Project URL** (under "Project URL")
   - **anon/public key** (under "Project API keys")

## Step 3: Set Up Environment Variables

1. Create a `.env.local` file in the root of your project (if it doesn't exist)
2. Add the following variables:

```env
NEXT_PUBLIC_SUPABASE_URL=your_project_url_here
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key_here
```

Replace `your_project_url_here` and `your_anon_key_here` with the values from Step 2.

## Step 4: Create the Database Tables

1. In your Supabase project dashboard, go to **SQL Editor**
2. Click "New query"
3. Copy the entire contents of `supabase/schema.sql`
4. Paste it into the SQL Editor
5. Click "Run" (or press Cmd/Ctrl + Enter)
6. Wait for the query to complete successfully

The schema will create:
- `car_brands` table
- `car_models` table
- `car_modifications` table
- All necessary indexes and Row Level Security policies
- Sample data for 10 European car brands with their models and modifications

## Step 5: Verify the Setup

1. In Supabase dashboard, go to **Table Editor**
2. You should see three tables: `car_brands`, `car_models`, and `car_modifications`
3. Check that they contain data (especially `car_brands` should have 10 rows)

## Step 6: Test the Application

1. Start your Next.js development server:
   ```bash
   npm run dev
   ```

2. Open [http://localhost:3000](http://localhost:3000)
3. The car selection dropdowns should now be populated with data from Supabase
4. If Supabase is not configured, the app will fall back to the hardcoded database

## Troubleshooting

### "Error fetching car data from Supabase"
- Check that your `.env.local` file exists and contains the correct values
- Verify that the environment variables start with `NEXT_PUBLIC_`
- Restart your development server after adding environment variables
- Check the browser console for detailed error messages

### Tables are empty
- Make sure you ran the SQL schema file completely
- Check the SQL Editor for any error messages
- Verify that the INSERT statements executed successfully

### Can't connect to Supabase
- Check your internet connection
- Verify that your Supabase project is active (not paused)
- Check Supabase status page: [https://status.supabase.com](https://status.supabase.com)

## Adding More Cars

You can add more cars to the database by:

1. **Using the Supabase Dashboard:**
   - Go to **Table Editor**
   - Select the appropriate table
   - Click "Insert row" and fill in the data

2. **Using SQL:**
   - Go to **SQL Editor**
   - Write INSERT statements following the same pattern as in `schema.sql`

3. **Using the Supabase Client:**
   - You can create an admin interface or use the Supabase client directly in your code

## Database Structure

```
car_brands
├── id (primary key)
├── name (unique)
└── created_at

car_models
├── id (primary key)
├── brand_id (foreign key → car_brands.id)
├── name
└── created_at

car_modifications
├── id (primary key)
├── model_id (foreign key → car_models.id)
├── name
└── created_at
```

## Security

The database uses Row Level Security (RLS) with public read access. This means:
- Anyone can read the car data (no authentication required)
- Only authenticated users can write data (if you add authentication later)
- You can modify the RLS policies in the Supabase dashboard if needed

