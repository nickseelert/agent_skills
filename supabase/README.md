# Supabase Skill

A skill for AI coding agents to interact with Supabase projects via the Supabase CLI.

## What This Skill Does

This skill enables AI agents to:
- Manage Supabase databases (queries, migrations, schema operations)
- Deploy and manage Edge Functions
- Work with local development environments
- Generate TypeScript types from database schemas

## Installation

See the [main repository README](../README.md) for installation instructions.

## Configuration

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

## Prerequisites

- **Supabase CLI**: Install as a dev dependency in your project:
  ```bash
  npm i supabase --save-dev
  ```
  Or via Homebrew (macOS/Linux):
  ```bash
  brew install supabase/tap/supabase
  ```
  **Note**: Global npm install (`npm i -g supabase`) is not supported.
- **Docker**: Required for local development (`supabase start`)
- **Network access**: Required for remote operations

## Helper Scripts

The `scripts/` directory contains helper scripts that read from `.supabase-skill.json`:

| Script | Description |
|--------|-------------|
| `execute-sql.sh` | Execute SQL queries against local or remote database |
| `list-tables.sh` | List all tables in a schema |
| `describe-table.sh` | Get detailed table information |
| `quick-query.sh` | Common database queries (tables, views, extensions, sizes, etc.) |
| `deploy-function.sh` | Deploy Edge Functions |
| `generate-migration.sh` | Create migration files |

### Examples

```bash
# Execute SQL
./scripts/execute-sql.sh "SELECT * FROM users LIMIT 5"
./scripts/execute-sql.sh --linked "SELECT count(*) FROM orders"

# List tables
./scripts/list-tables.sh
./scripts/list-tables.sh --linked auth

# Quick queries
./scripts/quick-query.sh tables
./scripts/quick-query.sh table-sizes
./scripts/quick-query.sh count users
```

## Resources

- [Supabase CLI Docs](https://supabase.com/docs/reference/cli/introduction)
- [Local Development Guide](https://supabase.com/docs/guides/local-development)
- [Database Migrations](https://supabase.com/docs/guides/deployment/database-migrations)
- [Edge Functions](https://supabase.com/docs/guides/functions)

## License

MIT
