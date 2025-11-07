#!/bin/bash

# Script to push local Supabase migrations and data to remote
# Usage: ./scripts/push-to-remote.sh [project-ref]

set -e

echo "🚀 Pushing local Supabase data to remote..."
echo ""

# Check if project ref is provided
if [ -z "$1" ]; then
    echo "❌ Error: Project reference is required"
    echo ""
    echo "Usage: ./scripts/push-to-remote.sh <project-ref>"
    echo ""
    echo "To get your project reference:"
    echo "1. Go to https://supabase.com/dashboard"
    echo "2. Select your project"
    echo "3. Go to Settings > General"
    echo "4. Copy the 'Reference ID' (it looks like: abcdefghijklmnopqrst)"
    echo ""
    echo "Or run: supabase projects list"
    exit 1
fi

PROJECT_REF=$1

echo "📋 Steps to push local data to remote:"
echo ""
echo "1️⃣  Login to Supabase CLI (if not already logged in):"
echo "   supabase login"
echo ""
echo "2️⃣  Link your local project to remote:"
echo "   supabase link --project-ref $PROJECT_REF"
echo ""
echo "3️⃣  Push migrations to remote:"
echo "   supabase db push"
echo ""
echo "⚠️  Note: This will apply all local migrations to your remote database."
echo "   Make sure you have a backup if needed!"
echo ""
read -p "Do you want to proceed with linking? (y/n) " -n 1 -r
echo ""

if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "🔗 Linking to project: $PROJECT_REF"
    supabase link --project-ref $PROJECT_REF
    
    echo ""
    echo "📤 Pushing migrations..."
    supabase db push
    
    echo ""
    echo "✅ Done! Your local migrations have been pushed to remote."
    echo ""
    echo "To verify, check your Supabase dashboard:"
    echo "https://supabase.com/dashboard/project/$PROJECT_REF"
else
    echo "❌ Cancelled."
    exit 1
fi

