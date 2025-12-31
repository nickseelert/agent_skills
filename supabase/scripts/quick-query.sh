#!/usr/bin/env bash
# Quick query helper for common operations
# Usage: ./quick-query.sh [--local|--linked] <command> [args]

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

TARGET=""
COMMAND=""
ARGS=()

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
            if [[ -z "$COMMAND" ]]; then
                COMMAND="$1"
            else
                ARGS+=("$1")
            fi
            shift
            ;;
    esac
done

# Use config default if no target specified
if [[ -z "$TARGET" ]]; then
    TARGET=$(get_target_flag "--local")
fi

# Get default schema from config
DEFAULT_SCHEMA=$(get_config "default-schema" "public")

case "$COMMAND" in
    tables)
        # List all tables
        echo "\dt ${ARGS[0]:-$DEFAULT_SCHEMA}.*" | supabase db psql $TARGET
        ;;
    views)
        # List all views
        echo "\dv ${ARGS[0]:-$DEFAULT_SCHEMA}.*" | supabase db psql $TARGET
        ;;
    functions)
        # List all functions
        echo "\df ${ARGS[0]:-$DEFAULT_SCHEMA}.*" | supabase db psql $TARGET
        ;;
    extensions)
        # List extensions
        echo "SELECT * FROM pg_extension ORDER BY extname;" | supabase db psql $TARGET
        ;;
    roles)
        # List roles
        echo "\du" | supabase db psql $TARGET
        ;;
    size)
        # Database size
        SQL="SELECT pg_size_pretty(pg_database_size(current_database())) as size;"
        echo "$SQL" | supabase db psql $TARGET
        ;;
    table-sizes)
        # Table sizes
        SQL=$(cat <<'EOF'
SELECT
    schemaname,
    tablename,
    pg_size_pretty(pg_total_relation_size(schemaname || '.' || tablename)) as total_size,
    pg_size_pretty(pg_relation_size(schemaname || '.' || tablename)) as table_size,
    pg_size_pretty(pg_indexes_size(schemaname || '.' || tablename)) as index_size
FROM pg_tables
WHERE schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY pg_total_relation_size(schemaname || '.' || tablename) DESC
LIMIT 20;
EOF
)
        echo "$SQL" | supabase db psql $TARGET
        ;;
    count)
        # Count rows in table
        TABLE="${ARGS[0]}"
        if [[ -z "$TABLE" ]]; then
            echo "Usage: $0 count <table_name>"
            exit 1
        fi
        echo "SELECT count(*) FROM $TABLE;" | supabase db psql $TARGET
        ;;
    select)
        # Select from table with limit
        TABLE="${ARGS[0]}"
        LIMIT="${ARGS[1]:-10}"
        if [[ -z "$TABLE" ]]; then
            echo "Usage: $0 select <table_name> [limit]"
            exit 1
        fi
        echo "SELECT * FROM $TABLE LIMIT $LIMIT;" | supabase db psql $TARGET
        ;;
    policies)
        # List RLS policies
        SQL=$(cat <<'EOF'
SELECT
    schemaname,
    tablename,
    policyname,
    permissive,
    roles,
    cmd,
    qual,
    with_check
FROM pg_policies
ORDER BY schemaname, tablename, policyname;
EOF
)
        echo "$SQL" | supabase db psql $TARGET
        ;;
    triggers)
        # List triggers
        SQL=$(cat <<'EOF'
SELECT
    trigger_schema,
    trigger_name,
    event_object_table,
    event_manipulation,
    action_timing
FROM information_schema.triggers
WHERE trigger_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY trigger_schema, event_object_table, trigger_name;
EOF
)
        echo "$SQL" | supabase db psql $TARGET
        ;;
    *)
        echo "Quick Query Helper"
        echo "Usage: $0 [--local|--linked] <command> [args]"
        echo ""
        echo "Commands:"
        echo "  tables [schema]      List all tables"
        echo "  views [schema]       List all views"
        echo "  functions [schema]   List all functions"
        echo "  extensions           List installed extensions"
        echo "  roles                List database roles"
        echo "  size                 Show database size"
        echo "  table-sizes          Show table sizes"
        echo "  count <table>        Count rows in table"
        echo "  select <table> [n]   Select n rows from table (default: 10)"
        echo "  policies             List RLS policies"
        echo "  triggers             List triggers"
        echo ""
        echo "Config: Set defaults in .supabase-skill.json"
        exit 1
        ;;
esac
