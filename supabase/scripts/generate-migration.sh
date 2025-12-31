#!/usr/bin/env bash
# Generate a migration from SQL or diff
# Usage: ./generate-migration.sh <name> [sql]

set -e

NAME="$1"
SQL="$2"

if [[ -z "$NAME" ]]; then
    echo "Usage: $0 <migration-name> [sql]"
    echo ""
    echo "Examples:"
    echo "  $0 create_users_table                    # Create empty migration"
    echo "  $0 add_email_column 'ALTER TABLE ...'    # Create with SQL"
    echo "  echo 'SQL' | $0 my_migration             # Pipe SQL"
    exit 1
fi

# Create migration
if [[ -n "$SQL" ]]; then
    echo "$SQL" | supabase migration new "$NAME"
elif [[ ! -t 0 ]]; then
    # Reading from stdin
    cat | supabase migration new "$NAME"
else
    supabase migration new "$NAME"
fi

echo "Migration created. Files in supabase/migrations/"
ls -la supabase/migrations/ 2>/dev/null | tail -5
