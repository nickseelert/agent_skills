---
name: supabase
description: Interact with Supabase projects via the Supabase CLI. Manage databases, run SQL queries, handle migrations, deploy Edge Functions, manage storage, and work with branching. Use when the user mentions Supabase, needs database operations, wants to deploy serverless functions, or work with Postgres databases hosted on Supabase. Replaces Supabase MCP functionality.
license: MIT
compatibility: Requires Supabase CLI installed (npm i -g supabase or brew install supabase/tap/supabase). Requires Docker for local development. Network access needed for remote operations.
---

# Supabase

Interact with Supabase projects using the Supabase CLI. This skill provides all the functionality of the Supabase MCP as a drop-in replacement.

## Configuration File

Create a `.supabase-skill.json` file to configure access to your Supabase project.

### Quick Setup

```bash
# Option 1: Global config (for all projects using the same Supabase account)
cp /path/to/agent_skills/supabase/templates/supabase-skill.example.json ~/.supabase-skill.json

# Option 2: Project-specific config (in your project root)
cp /path/to/agent_skills/supabase/templates/supabase-skill.example.json ./.supabase-skill.json
```

Then edit the file with your actual values (see below for where to find them).

### Example Config

```json
{
  "project-ref": "abcdefghijklmnop",
  "access-token": "sbp_1234567890abcdef...",
  "db-password": "your-database-password",
  "default-target": "local",
  "default-schema": "public"
}
```

### Where to Find Each Value

| Field | Required? | Where to Find It |
|-------|-----------|------------------|
| `project-ref` | Yes (for remote ops) | Supabase Dashboard → Project Settings → General → "Reference ID" (looks like `abcdefghijklmnop`) |
| `access-token` | Yes (for remote ops) | Supabase Dashboard → Account (top right) → Access Tokens → Generate New Token (starts with `sbp_`) |
| `db-password` | Optional | The password you set when creating the project, or reset in Dashboard → Project Settings → Database → Database Password |
| `db-url` | Optional | Full postgres connection string. If set, overrides `project-ref` for database operations. Find in Dashboard → Project Settings → Database → Connection string |
| `default-target` | Optional | `local` (default) or `linked`. Controls whether scripts target local Docker or remote by default |
| `default-schema` | Optional | `public` (default). The schema to use for table listings and queries |
| `org-id` | Optional | Only needed for creating new projects. Dashboard → Organization Settings → General → Organization ID |

### Minimal Config for Remote Operations

If you just want to query your remote Supabase database:

```json
{
  "project-ref": "your-project-ref",
  "access-token": "sbp_your-access-token"
}
```

### Minimal Config for Local Development

For local development with Docker, you don't need any config - just run `supabase start`. But you can set defaults:

```json
{
  "default-target": "local",
  "default-schema": "public"
}
```

**Security Note:** Add `.supabase-skill.json` to your `.gitignore` to avoid committing secrets.

The helper scripts in `scripts/` automatically read this config. You can also set environment variables:

```bash
export SUPABASE_ACCESS_TOKEN="sbp_xxxxx"
export SUPABASE_PROJECT_REF="your-project-ref"
```

## Setup

### Install Supabase CLI

```bash
# Via npm (recommended)
npm install -g supabase

# Via Homebrew (macOS/Linux)
brew install supabase/tap/supabase

# Verify installation
supabase --version
```

### Authentication

```bash
# Login to Supabase (opens browser for OAuth)
supabase login

# Or use access token (for CI/scripts)
# Get token from: https://supabase.com/dashboard/account/tokens
export SUPABASE_ACCESS_TOKEN="your-token-here"
```

### Link to Existing Project

```bash
# Link current directory to a Supabase project
supabase link --project-ref <project-id>

# Find project-id in: Supabase Dashboard > Project Settings > General
```

### Initialize New Project

```bash
# Create local Supabase project structure
supabase init

# Start local development stack (requires Docker)
supabase start
```

## Account Management

### List Projects

```bash
# List all projects in your account
supabase projects list
```

### Get Project Info

```bash
# Get details about linked project
supabase projects show

# Get project API settings
supabase projects api-keys
```

### Create Project

```bash
# Create new project (interactive)
supabase projects create <project-name> \
  --org-id <org-id> \
  --db-password <password> \
  --region <region>

# Available regions: us-east-1, us-west-1, eu-west-1, ap-southeast-1, etc.
```

### Pause/Resume Project

```bash
# Pause project (stops billing for compute)
supabase projects pause --project-ref <project-id>

# Resume paused project
supabase projects resume --project-ref <project-id>
```

### Organizations

```bash
# List organizations
supabase orgs list
```

## Database Operations

### Execute SQL

```bash
# Run SQL query against local database
supabase db execute --local -f query.sql

# Run SQL against linked remote project
supabase db execute --linked -f query.sql

# Run inline SQL
echo "SELECT * FROM users LIMIT 10;" | supabase db execute --local

# Connect directly with psql (local)
supabase db psql --local

# Get connection string for external tools
supabase db url --local
```

### List Tables

```bash
# Show database schema
supabase db lint --linked

# Or use psql for detailed info
echo "\dt public.*" | supabase db psql --local
echo "\d+ tablename" | supabase db psql --local
```

### List Extensions

```bash
# Via psql
echo "SELECT * FROM pg_extension;" | supabase db psql --local
```

## Migrations

### Create Migration

```bash
# Create empty migration file
supabase migration new <migration-name>

# Generate migration from schema diff (local changes vs migrations)
supabase db diff -f <migration-name>

# Generate migration from linked project diff
supabase db diff --linked -f <migration-name>
```

### Apply Migrations

```bash
# Apply pending migrations to local database
supabase db reset

# Apply migrations to remote/linked project
supabase db push

# Run specific migration up
supabase migration up --local

# Rollback migration
supabase migration down --local
```

### List Migrations

```bash
# Show migration status (local vs remote)
supabase migration list
```

### Repair Migrations

```bash
# Mark migration as applied without running it
supabase migration repair --status applied <timestamp>

# Mark migration as reverted
supabase migration repair --status reverted <timestamp>
```

## Edge Functions

### List Functions

```bash
# List all deployed edge functions
supabase functions list
```

### Create Function

```bash
# Create new edge function
supabase functions new <function-name>

# This creates: supabase/functions/<function-name>/index.ts
```

### Deploy Function

```bash
# Deploy single function
supabase functions deploy <function-name>

# Deploy all functions
supabase functions deploy

# Deploy with specific project
supabase functions deploy <function-name> --project-ref <project-id>
```

### Serve Functions Locally

```bash
# Start local function server
supabase functions serve

# Serve specific function
supabase functions serve <function-name>

# With environment variables
supabase functions serve --env-file .env.local
```

### Delete Function

```bash
supabase functions delete <function-name>
```

## TypeScript Types

### Generate Types

```bash
# Generate types from local database
supabase gen types typescript --local > src/types/supabase.ts

# Generate from linked project
supabase gen types typescript --linked > src/types/supabase.ts

# Generate from specific project
supabase gen types typescript --project-id <project-id> > src/types/supabase.ts
```

## Storage

### List Buckets

```bash
# Via SQL
echo "SELECT * FROM storage.buckets;" | supabase db psql --local
```

### Manage Storage

```bash
# Storage operations are typically done via SQL or the Supabase client library
# Create bucket via migration:
cat << 'EOF' | supabase migration new create_bucket
INSERT INTO storage.buckets (id, name, public)
VALUES ('avatars', 'avatars', true);
EOF
```

## Branching (Preview Branches)

Requires paid plan. Creates isolated database copies for testing.

### Create Branch

```bash
supabase branches create <branch-name>
```

### List Branches

```bash
supabase branches list
```

### Delete Branch

```bash
supabase branches delete <branch-name>
```

### Switch Branch

```bash
supabase branches switch <branch-name>
```

## Logs & Debugging

### View Logs

```bash
# View API logs
supabase logs api --linked

# View Postgres logs
supabase logs postgres --linked

# View Edge Function logs
supabase logs functions --linked

# View auth logs
supabase logs auth --linked

# View storage logs
supabase logs storage --linked

# View realtime logs
supabase logs realtime --linked
```

### Inspect Services

```bash
# Check service status (local)
supabase status

# Get local service URLs
supabase status -o env
```

## Development Workflow

### Start Local Stack

```bash
# Start all services (Postgres, Auth, Storage, etc.)
supabase start

# View running services
supabase status
```

### Stop Local Stack

```bash
# Stop but keep data
supabase stop

# Stop and reset all data
supabase stop --no-backup
```

### Reset Database

```bash
# Reset local database (reapply all migrations + seed)
supabase db reset
```

### Seed Data

```bash
# Seed file location: supabase/seed.sql
# Runs automatically after migrations on db reset
```

## Configuration

### Project Config

Located at `supabase/config.toml`:

```toml
[project]
id = "your-project-ref"
name = "your-project-name"

[db]
port = 54322
shadow_port = 54320
major_version = 15

[api]
enabled = true
port = 54321
schemas = ["public", "graphql_public"]
extra_search_path = ["public", "extensions"]
max_rows = 1000

[auth]
enabled = true
site_url = "http://localhost:3000"

[storage]
enabled = true
file_size_limit = "50MiB"

[functions]
enabled = true
```

### Environment Variables

```bash
# For edge functions, create .env file or use --env-file flag
# supabase/functions/.env

OPENAI_API_KEY=sk-xxx
STRIPE_SECRET_KEY=sk_xxx
```

## API Keys & URLs

### Get Project URL

```bash
# From status (local)
supabase status | grep "API URL"

# For linked project, check dashboard or:
supabase projects show
```

### Get API Keys

```bash
# List API keys for linked project
supabase projects api-keys

# Local development uses default keys shown in `supabase status`
```

## Common Workflows

### Fresh Start for New Feature

```bash
# 1. Create branch (if on paid plan)
supabase branches create feature-xyz

# 2. Or reset local and apply migrations
supabase db reset

# 3. Make schema changes directly in local DB
# 4. Generate migration from diff
supabase db diff -f my_changes

# 5. Test locally
supabase db reset

# 6. Push to remote when ready
supabase db push
```

### Pull Remote Schema Changes

```bash
# Pull migrations from linked project
supabase db pull

# This creates migration files from remote schema
```

### Deploy Everything

```bash
# Push database migrations
supabase db push

# Deploy all edge functions
supabase functions deploy

# Generate fresh types
supabase gen types typescript --linked > src/types/supabase.ts
```

## Troubleshooting

### Docker Issues

```bash
# Ensure Docker is running
docker info

# Clean up Supabase containers
supabase stop --no-backup
docker system prune
supabase start
```

### Connection Issues

```bash
# Check if services are running
supabase status

# Verify project link
supabase projects show

# Re-authenticate
supabase login
```

### Migration Conflicts

```bash
# Check migration status
supabase migration list

# Repair if needed
supabase migration repair --status applied <timestamp>

# Force reset (destructive)
supabase db reset
```

## Helper Scripts

This skill includes helper scripts in the `scripts/` directory that read from `.supabase-skill.json`:

### execute-sql.sh

Execute SQL against local or remote database:

```bash
./scripts/execute-sql.sh "SELECT * FROM users LIMIT 5"
./scripts/execute-sql.sh --linked "SELECT count(*) FROM orders"
./scripts/execute-sql.sh -f query.sql
```

### list-tables.sh

List all tables in a schema:

```bash
./scripts/list-tables.sh              # Uses default-schema from config
./scripts/list-tables.sh --linked     # List from remote
./scripts/list-tables.sh auth         # List tables in auth schema
```

### describe-table.sh

Get detailed table information:

```bash
./scripts/describe-table.sh users
./scripts/describe-table.sh --linked orders
./scripts/describe-table.sh profiles public
```

### quick-query.sh

Common database queries:

```bash
./scripts/quick-query.sh tables           # List all tables
./scripts/quick-query.sh views            # List all views
./scripts/quick-query.sh extensions       # List extensions
./scripts/quick-query.sh size             # Database size
./scripts/quick-query.sh table-sizes      # Size of each table
./scripts/quick-query.sh count users      # Count rows in table
./scripts/quick-query.sh select users 5   # Select 5 rows from table
./scripts/quick-query.sh policies         # List RLS policies
./scripts/quick-query.sh triggers         # List triggers
```

### deploy-function.sh

Deploy edge functions:

```bash
./scripts/deploy-function.sh my-function
./scripts/deploy-function.sh my-function --no-verify-jwt
./scripts/deploy-function.sh my-function --project your-project-ref
```

### generate-migration.sh

Create migrations:

```bash
./scripts/generate-migration.sh create_users_table
./scripts/generate-migration.sh add_column "ALTER TABLE users ADD COLUMN email TEXT"
echo "CREATE TABLE posts (...);" | ./scripts/generate-migration.sh create_posts
```

## Reference

- [Supabase CLI Docs](https://supabase.com/docs/reference/cli/introduction)
- [Local Development Guide](https://supabase.com/docs/guides/local-development)
- [Database Migrations](https://supabase.com/docs/guides/deployment/database-migrations)
- [Edge Functions](https://supabase.com/docs/guides/functions)
