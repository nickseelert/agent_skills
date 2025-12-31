#!/usr/bin/env bash
# Deploy an edge function with options
# Usage: ./deploy-function.sh <function-name> [options]

set -e
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/config.sh"

FUNCTION=""
PROJECT=""
VERIFY_JWT="true"
IMPORT_MAP=""

while [[ $# -gt 0 ]]; do
    case $1 in
        --project)
            PROJECT="--project-ref $2"
            shift 2
            ;;
        --no-verify-jwt)
            VERIFY_JWT="false"
            shift
            ;;
        --import-map)
            IMPORT_MAP="--import-map $2"
            shift 2
            ;;
        *)
            FUNCTION="$1"
            shift
            ;;
    esac
done

# Use config default for project if not specified
if [[ -z "$PROJECT" ]]; then
    PROJECT=$(get_project_flag)
fi

if [[ -z "$FUNCTION" ]]; then
    echo "Usage: $0 <function-name> [options]"
    echo ""
    echo "Options:"
    echo "  --project <ref>     Deploy to specific project"
    echo "  --no-verify-jwt     Disable JWT verification"
    echo "  --import-map <path> Use custom import map"
    echo ""
    echo "Config: Set project-ref in .supabase-skill.json"
    exit 1
fi

VERIFY_FLAG=""
if [[ "$VERIFY_JWT" == "false" ]]; then
    VERIFY_FLAG="--no-verify-jwt"
fi

echo "Deploying function: $FUNCTION"
supabase functions deploy "$FUNCTION" $PROJECT $VERIFY_FLAG $IMPORT_MAP

echo ""
echo "Function deployed successfully!"
echo "Test with: supabase functions invoke $FUNCTION --body '{\"name\": \"test\"}'"
