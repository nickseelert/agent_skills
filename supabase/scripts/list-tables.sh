#!/usr/bin/env bash
# List all tables in the database with details
# Usage: ./list-tables.sh [--local|--linked] [schema]

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

TARGET=""
SCHEMA=""

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
        *)
            SCHEMA="$1"
            shift
            ;;
    esac
done

# Use config defaults
if [[ -z "$TARGET" ]]; then
    TARGET=$(get_target_flag "--local")
fi

if [[ -z "$SCHEMA" ]]; then
    SCHEMA=$(get_config "default-schema" "public")
fi

echo "Tables in schema '$SCHEMA':"
echo ""

SQL=$(cat <<EOF
SELECT 
    table_name,
    (SELECT count(*) FROM information_schema.columns c WHERE c.table_schema = t.table_schema AND c.table_name = t.table_name) as column_count
FROM information_schema.tables t
WHERE table_schema = '$SCHEMA'
AND table_type = 'BASE TABLE'
ORDER BY table_name;
EOF
)

echo "$SQL" | supabase db psql $TARGET
