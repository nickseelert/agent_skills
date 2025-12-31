#!/usr/bin/env bash
# Describe a table's structure
# Usage: ./describe-table.sh [--local|--linked] <table_name> [schema]

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

TARGET=""
TABLE=""
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
            if [[ -z "$TABLE" ]]; then
                TABLE="$1"
            else
                SCHEMA="$1"
            fi
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

if [[ -z "$TABLE" ]]; then
    echo "Usage: $0 [--local|--linked] <table_name> [schema]"
    exit 1
fi

echo "Structure of table '$SCHEMA.$TABLE':"
echo ""

SQL=$(cat <<EOF
SELECT 
    column_name,
    data_type,
    is_nullable,
    column_default,
    character_maximum_length
FROM information_schema.columns
WHERE table_schema = '$SCHEMA'
AND table_name = '$TABLE'
ORDER BY ordinal_position;
EOF
)

echo "$SQL" | supabase db psql $TARGET

echo ""
echo "Indexes:"

SQL2=$(cat <<EOF
SELECT
    indexname,
    indexdef
FROM pg_indexes
WHERE schemaname = '$SCHEMA'
AND tablename = '$TABLE';
EOF
)

echo "$SQL2" | supabase db psql $TARGET

echo ""
echo "Foreign Keys:"

SQL3=$(cat <<EOF
SELECT
    tc.constraint_name,
    kcu.column_name,
    ccu.table_schema AS foreign_table_schema,
    ccu.table_name AS foreign_table_name,
    ccu.column_name AS foreign_column_name
FROM information_schema.table_constraints AS tc
JOIN information_schema.key_column_usage AS kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage AS ccu
    ON ccu.constraint_name = tc.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
AND tc.table_schema = '$SCHEMA'
AND tc.table_name = '$TABLE';
EOF
)

echo "$SQL3" | supabase db psql $TARGET
