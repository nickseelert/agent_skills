# Supabase CLI Quick Reference

## Authentication & Setup

| Command | Description |
|---------|-------------|
| `supabase login` | Login via browser OAuth |
| `supabase logout` | Clear stored credentials |
| `supabase init` | Initialize new project |
| `supabase link --project-ref <id>` | Link to remote project |
| `supabase start` | Start local dev stack |
| `supabase stop` | Stop local stack |
| `supabase status` | Show service status/URLs |

## Projects

| Command | Description |
|---------|-------------|
| `supabase projects list` | List all projects |
| `supabase projects show` | Show linked project details |
| `supabase projects api-keys` | Get API keys |
| `supabase projects create <name>` | Create new project |
| `supabase projects pause` | Pause project |
| `supabase projects resume` | Resume project |

## Database

| Command | Description |
|---------|-------------|
| `supabase db psql --local` | Connect to local DB |
| `supabase db psql --linked` | Connect to remote DB |
| `supabase db execute -f <file>` | Run SQL file |
| `supabase db reset` | Reset DB (rerun migrations) |
| `supabase db push` | Push migrations to remote |
| `supabase db pull` | Pull remote schema |
| `supabase db diff -f <name>` | Generate diff migration |
| `supabase db lint` | Check for schema errors |
| `supabase db url` | Get connection string |

## Migrations

| Command | Description |
|---------|-------------|
| `supabase migration new <name>` | Create migration file |
| `supabase migration list` | Show migration status |
| `supabase migration up` | Apply next migration |
| `supabase migration down` | Rollback last migration |
| `supabase migration repair` | Fix migration state |
| `supabase migration squash` | Combine migrations |

## Edge Functions

| Command | Description |
|---------|-------------|
| `supabase functions new <name>` | Create function |
| `supabase functions list` | List functions |
| `supabase functions serve` | Run locally |
| `supabase functions deploy` | Deploy all |
| `supabase functions deploy <name>` | Deploy specific |
| `supabase functions delete <name>` | Delete function |
| `supabase functions invoke <name>` | Test function |

## Type Generation

| Command | Description |
|---------|-------------|
| `supabase gen types typescript --local` | From local DB |
| `supabase gen types typescript --linked` | From remote DB |
| `supabase gen types typescript --project-id <id>` | From specific project |

## Logs

| Command | Description |
|---------|-------------|
| `supabase logs api` | API gateway logs |
| `supabase logs postgres` | Database logs |
| `supabase logs functions` | Edge function logs |
| `supabase logs auth` | Authentication logs |
| `supabase logs storage` | Storage logs |
| `supabase logs realtime` | Realtime logs |

## Branches (Paid Plans)

| Command | Description |
|---------|-------------|
| `supabase branches create <name>` | Create branch |
| `supabase branches list` | List branches |
| `supabase branches delete <name>` | Delete branch |
| `supabase branches switch <name>` | Switch to branch |

## Secrets

| Command | Description |
|---------|-------------|
| `supabase secrets list` | List secrets |
| `supabase secrets set <KEY>=<value>` | Set secret |
| `supabase secrets unset <KEY>` | Remove secret |

## Storage

| Command | Description |
|---------|-------------|
| `supabase storage ls` | List buckets |
| `supabase storage ls <bucket>` | List objects |
| `supabase storage cp <src> <dst>` | Copy file |
| `supabase storage rm <path>` | Remove file |
| `supabase storage mv <src> <dst>` | Move file |

## Common Flags

| Flag | Description |
|------|-------------|
| `--local` | Target local database |
| `--linked` | Target linked remote project |
| `--project-ref <id>` | Target specific project |
| `--db-url <url>` | Target database by URL |
| `-f, --file` | Read from file |
| `--debug` | Show debug output |
| `-h, --help` | Show help |

## Environment Variables

| Variable | Description |
|----------|-------------|
| `SUPABASE_ACCESS_TOKEN` | API access token |
| `SUPABASE_DB_PASSWORD` | Database password |
| `SUPABASE_PROJECT_REF` | Default project reference |

## Local Development URLs (defaults)

| Service | URL |
|---------|-----|
| API | http://localhost:54321 |
| Studio | http://localhost:54323 |
| Inbucket (email) | http://localhost:54324 |
| Database | postgresql://postgres:postgres@localhost:54322/postgres |
| Storage | http://localhost:54321/storage/v1 |
| Functions | http://localhost:54321/functions/v1 |
