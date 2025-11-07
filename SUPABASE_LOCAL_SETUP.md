# Supabase Local Setup Guide

This guide will help you set up and run Supabase locally for development.

## Prerequisites

1. **Docker Desktop** - Supabase local requires Docker
   - Download from: https://www.docker.com/products/docker-desktop
   - Make sure Docker Desktop is running before proceeding

2. **Supabase CLI** - Already installed ✅
   - Verify: `supabase --version`

## Step 1: Start Docker Desktop

1. Open Docker Desktop application
2. Wait until Docker is fully started (whale icon in menu bar should be steady)
3. Verify Docker is running:
   ```bash
   docker ps
   ```

## Step 2: Start Supabase Locally

Once Docker is running, start Supabase:

```bash
supabase start
```

This will:
- Download and start all required Docker containers
- Set up PostgreSQL database
- Set up Supabase services (Auth, Storage, etc.)
- Take a few minutes on first run

## Step 3: Get Local Credentials

After Supabase starts, you'll see output with your local credentials. You can also get them anytime with:

```bash
supabase status
```

The output will show:
- API URL: `http://localhost:54321`
- anon key: (a long string)
- service_role key: (a long string)

## Step 4: Update Environment Variables

Create or update `.env.local` file in the project root:

```env
NEXT_PUBLIC_SUPABASE_URL=http://localhost:54321
NEXT_PUBLIC_SUPABASE_ANON_KEY=your_anon_key_here
```

Replace `your_anon_key_here` with the actual anon key from `supabase status`.

## Step 5: Verify Migration

The migration file has already been created at:
`supabase/migrations/20251107125441_initial_schema.sql`

When you run `supabase start`, migrations are automatically applied. To verify:

```bash
supabase db reset
```

This will reset the database and apply all migrations.

## Step 6: Verify Setup

1. Check Supabase is running:
   ```bash
   supabase status
   ```

2. Start your Next.js app:
   ```bash
   npm run dev
   ```

3. Open http://localhost:3000
4. The car selection dropdowns should be populated with data from your local Supabase

## Useful Commands

### Start Supabase
```bash
supabase start
```

### Stop Supabase
```bash
supabase stop
```

### View Supabase Status
```bash
supabase status
```

### Reset Database (applies all migrations)
```bash
supabase db reset
```

### View Logs
```bash
supabase logs
```

### Access Supabase Studio (Web UI)
After starting Supabase, open: http://localhost:54323

This gives you a web interface to:
- View and edit data
- Run SQL queries
- Manage tables
- View API documentation

### Create a New Migration
```bash
supabase migration new migration_name
```

### Apply Migrations Manually
```bash
supabase db reset
```

## Troubleshooting

### Docker is not running
- Make sure Docker Desktop is installed and running
- Check Docker status: `docker ps`

### Port conflicts
If ports 54321 or 54323 are already in use:
- Stop the conflicting service
- Or modify `supabase/config.toml` to use different ports

### Migration errors
If migrations fail:
```bash
supabase db reset
```

### Reset everything
To completely reset your local Supabase:
```bash
supabase stop
supabase start
```

## Next Steps

1. Start Docker Desktop
2. Run `supabase start`
3. Copy the anon key from the output
4. Update `.env.local` with the local URL and key
5. Run `npm run dev` and test the application

## Local vs Production

- **Local**: Uses `http://localhost:54321` and runs in Docker
- **Production**: Uses your Supabase project URL from supabase.com

Make sure to use the correct environment variables for each environment!

