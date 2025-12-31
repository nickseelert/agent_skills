#!/usr/bin/env bash
# Execute SQL against local or remote Supabase database
# Usage: ./execute-sql.sh [--local|--linked|--db-url <url>] <sql-or-file>

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

TARGET=""
SQL=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --local)
            TARGET="--local"
            shift
            ;;
        --linked)
            TARGET="--linked"
            shift
            ;;
        --db-url)
            TARGET="--db-url $2"
            shift 2
            ;;
        -f|--file)
            SQL=$(cat "$2")
            shift 2
            ;;
        *)
            SQL="$1"
            shift
            ;;
    esac
done

# Use config default if no target specified
if [[ -z "$TARGET" ]]; then
    TARGET=$(get_target_flag "--local")
fi

if [[ -z "$SQL" ]]; then
    echo "Usage: $0 [--local|--linked|--db-url <url>] <sql-or-file>"
    echo "  --local   Execute against local database (default)"
    echo "  --linked  Execute against linked remote project"
    echo "  --db-url  Execute against specific database URL"
    echo "  -f, --file  Read SQL from file"
    echo ""
    echo "Config: Set defaults in .supabase-skill.json"
    exit 1
fi

# Check if SQL is a file path
if [[ -f "$SQL" ]]; then
    supabase db execute $TARGET -f "$SQL"
else
    echo "$SQL" | supabase db psql $TARGET
fi
