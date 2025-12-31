---
name: supabase
description: Interact with Supabase projects via the Supabase CLI. Manage databases, run SQL queries, handle migrations, deploy Edge Functions, manage storage, and work with branching. Use when the user mentions Supabase, needs database operations, wants to deploy serverless functions, or work with Postgres databases hosted on Supabase.
license: MIT
compatibility: Requires Supabase CLI installed (npm i -g supabase or brew install supabase/tap/supabase). Requires Docker for local development. Network access needed for remote operations.
---

# Supabase

Interact with Supabase projects using the Supabase CLI.

## Configuration

The skill reads config from `.supabase-skill.json` (project root or `~/`). See [README.md](README.md) for setup instructions.

Key fields: `project-ref`, `access-token`, `db-password`, `default-target` (local|linked), `default-schema`.

Environment variables also work:
```bash
export SUPABASE_ACCESS_TOKEN="sbp_xxxxx"
export SUPABASE_PROJECT_REF="your-project-ref"
```

## Setup

```bash
# Install CLI
npm install -g supabase

# Login (opens browser)
supabase login

# Link to existing project
supabase link --project-ref <project-id>

# Or initialize new local project
supabase init
supabase start  # Requires Docker
```

## Database Operations

### Execute SQL

```bash
# Local database
supabase db execute --local -f query.sql
echo "SELECT * FROM users LIMIT 10;" | supabase db execute --local

# Remote/linked project
supabase db execute --linked -f query.sql

# Interactive psql
supabase db psql --local
```

### Helper Scripts

```bash
./scripts/execute-sql.sh "SELECT * FROM users LIMIT 5"
./scripts/execute-sql.sh --linked "SELECT count(*) FROM orders"
./scripts/list-tables.sh
./scripts/describe-table.sh users
./scripts/quick-query.sh tables|views|extensions|size|table-sizes|policies|triggers
./scripts/quick-query.sh count users
./scripts/quick-query.sh select users 5
```

## Migrations

```bash
# Create empty migration
supabase migration new <migration-name>

# Generate from schema diff
supabase db diff -f <migration-name>

# Apply migrations
supabase db reset        # Local: reset and reapply all
supabase db push         # Remote: apply pending migrations

# List/repair migrations
supabase migration list
supabase migration repair --status applied <timestamp>
```

### Helper Script

```bash
./scripts/generate-migration.sh create_users_table
./scripts/generate-migration.sh add_column "ALTER TABLE users ADD COLUMN email TEXT"
```

## Edge Functions

```bash
# Create function
supabase functions new <function-name>

# Deploy
supabase functions deploy <function-name>
supabase functions deploy  # All functions

# Serve locally
supabase functions serve
supabase functions serve --env-file .env.local

# List/delete
supabase functions list
supabase functions delete <function-name>
```

### Helper Script

```bash
./scripts/deploy-function.sh my-function
./scripts/deploy-function.sh my-function --no-verify-jwt
```

## TypeScript Types

```bash
supabase gen types typescript --local > src/types/supabase.ts
supabase gen types typescript --linked > src/types/supabase.ts
```

## Local Development

```bash
supabase start      # Start all services (Postgres, Auth, Storage, etc.)
supabase status     # View running services and URLs
supabase stop       # Stop (keeps data)
supabase stop --no-backup  # Stop and reset data
supabase db reset   # Reset database (reapply migrations + seed)
```

Seed file: `supabase/seed.sql` (runs after migrations on reset)

## Account & Projects

```bash
supabase projects list
supabase projects show
supabase projects api-keys

# Create project
supabase projects create <name> --org-id <org-id> --db-password <pw> --region <region>

# Pause/resume
supabase projects pause --project-ref <id>
supabase projects resume --project-ref <id>

# Organizations
supabase orgs list
```

## Logs

```bash
supabase logs api --linked
supabase logs postgres --linked
supabase logs functions --linked
supabase logs auth --linked
supabase logs storage --linked
```

## Branching (Paid Plans)

```bash
supabase branches create <branch-name>
supabase branches list
supabase branches switch <branch-name>
supabase branches delete <branch-name>
```

## Common Workflows

### New Feature Development

```bash
supabase db reset                        # Start fresh locally
# Make schema changes in local DB
supabase db diff -f my_changes           # Generate migration
supabase db reset                        # Test migration
supabase db push                         # Push to remote when ready
```

### Pull Remote Changes

```bash
supabase db pull  # Creates migration files from remote schema
```

### Deploy Everything

```bash
supabase db push
supabase functions deploy
supabase gen types typescript --linked > src/types/supabase.ts
```

## Configuration Files

### supabase/config.toml

```toml
[project]
id = "your-project-ref"

[db]
port = 54322
major_version = 15

[api]
port = 54321
schemas = ["public", "graphql_public"]

[auth]
enabled = true
site_url = "http://localhost:3000"

[storage]
file_size_limit = "50MiB"
```

### Edge Function Environment

Create `supabase/functions/.env`:
```
OPENAI_API_KEY=sk-xxx
STRIPE_SECRET_KEY=sk_xxx
```

## Troubleshooting

```bash
# Docker issues
docker info
supabase stop --no-backup
docker system prune
supabase start

# Connection issues
supabase status
supabase projects show
supabase login

# Migration conflicts
supabase migration list
supabase migration repair --status applied <timestamp>
supabase db reset  # Force reset (destructive)
```
