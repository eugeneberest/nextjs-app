# Push Local Data to Remote Supabase

This guide explains how to push your local database schema and data to your remote Supabase project.

## Method 1: Using Supabase CLI (Recommended)

### Step 1: Login to Supabase CLI

```bash
supabase login
```

This will open a browser window for authentication. Follow the prompts to complete login.

### Step 2: Link Your Local Project to Remote

First, get your project reference ID:
1. Go to https://supabase.com/dashboard
2. Select your project
3. Go to **Settings** → **General**
4. Copy the **Reference ID** (looks like: `abcdefghijklmnopqrst`)

Then link your project:

```bash
supabase link --project-ref YOUR_PROJECT_REF
```

Replace `YOUR_PROJECT_REF` with your actual project reference ID.

### Step 3: Push Migrations

Push all local migrations to remote:

```bash
supabase db push
```

This will:
- Apply all migrations from `supabase/migrations/` to your remote database
- Include schema creation, RLS policies, and all seed data

### Step 4: Verify

1. Go to your Supabase dashboard
2. Navigate to **Table Editor**
3. Verify that all tables exist and contain data:
   - `brands` (should have 4 brands)
   - `models` (should have 4 models)
   - `trims` (should have multiple trims for 2022 and 2024)
   - `powertrains` (should have many powertrain entries)
   - `tco_params` (should have TCO parameters)

## Method 2: Using SQL Editor (Alternative)

If you prefer not to use the CLI, you can run the SQL files directly in the Supabase dashboard:

### Step 1: Open SQL Editor

1. Go to your Supabase dashboard
2. Navigate to **SQL Editor**
3. Click **New query**

### Step 2: Run Migrations in Order

Run each migration file in order:

1. **Schema**: Copy and run `supabase/migrations/20240101000001_init_schema.sql`
2. **RLS**: Copy and run `supabase/migrations/20240101000002_setup_rls.sql`
3. **Seed Data**: Copy and run `supabase/migrations/20240101000003_seed_data.sql`
4. **TCO Params**: Copy and run `supabase/migrations/20240101000004_seed_tco_params.sql`

### Step 3: Verify

Check the Table Editor to ensure all data was inserted correctly.

## Quick Script

You can also use the provided script:

```bash
./scripts/push-to-remote.sh YOUR_PROJECT_REF
```

This script will guide you through the process interactively.

## Troubleshooting

### "Access token not provided"
- Run `supabase login` first

### "Project not found"
- Verify your project reference ID is correct
- Make sure you're logged in with the correct account

### "Migration conflicts"
- If remote database already has some tables, you may need to reset or manually handle conflicts
- Check the migration files use `ON CONFLICT DO NOTHING` for safe re-runs

### "Permission denied"
- Make sure you have admin access to the Supabase project
- Check that your account has the correct permissions

## What Gets Pushed

The following will be pushed to remote:

1. **Schema** (`20240101000001_init_schema.sql`):
   - `brands` table
   - `models` table
   - `trims` table
   - `powertrains` table
   - `tco_params` table
   - All indexes

2. **RLS Policies** (`20240101000002_setup_rls.sql`):
   - Row Level Security enabled
   - Public read access
   - Service role full access

3. **Seed Data** (`20240101000003_seed_data.sql`):
   - 4 brands (Volkswagen, Audi, Hyundai, Volvo)
   - 4 models
   - Multiple trims for 2022 and 2024 model years
   - All powertrain configurations

4. **TCO Parameters** (`20240101000004_seed_tco_params.sql`):
   - Fuel prices
   - Insurance costs
   - Maintenance costs
   - Tax information
   - Depreciation values
   - For all fuel types (petrol, diesel, HEV, PHEV, BEV)

## Next Steps

After pushing to remote:

1. Update your `.env.local` or production environment variables:
   ```env
   NEXT_PUBLIC_SUPABASE_URL=https://your-project.supabase.co
   NEXT_PUBLIC_SUPABASE_ANON_KEY=your-anon-key
   ```

2. Test your application with the remote database

3. Monitor your Supabase dashboard for any issues

