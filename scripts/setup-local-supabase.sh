#!/bin/bash

# Supabase Local Setup Script
# This script helps set up Supabase locally

set -e

echo "🚀 Setting up Supabase locally..."

# Check if Docker is running
if ! docker ps > /dev/null 2>&1; then
    echo "❌ Docker is not running!"
    echo "Please start Docker Desktop and try again."
    exit 1
fi

echo "✅ Docker is running"

# Check if Supabase CLI is installed
if ! command -v supabase &> /dev/null; then
    echo "❌ Supabase CLI is not installed!"
    echo "Install it with: brew install supabase/tap/supabase"
    exit 1
fi

echo "✅ Supabase CLI is installed"

# Start Supabase
echo "📦 Starting Supabase..."
supabase start

# Get status and credentials
echo ""
echo "📋 Supabase Status:"
supabase status

echo ""
echo "✅ Setup complete!"
echo ""
echo "Next steps:"
echo "1. Copy the API URL and anon key from above"
echo "2. Update .env.local with:"
echo "   NEXT_PUBLIC_SUPABASE_URL=http://localhost:54321"
echo "   NEXT_PUBLIC_SUPABASE_ANON_KEY=<your_anon_key>"
echo "3. Run: npm run dev"
echo ""
echo "Access Supabase Studio at: http://localhost:54323"

