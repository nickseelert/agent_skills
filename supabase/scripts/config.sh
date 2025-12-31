#!/usr/bin/env bash
# Supabase Skill Configuration Helper
# Sources configuration from .supabase-skill.json files

# Config file locations (later wins):
# 1. ~/.supabase-skill.json (user global)
# 2. ./.supabase-skill.json (project local)

load_supabase_config() {
    local config_value=""
    
    # Check for jq
    if ! command -v jq &> /dev/null; then
        echo "Warning: jq not installed, cannot read config files" >&2
        return 1
    fi
    
    # Load from home directory first
    if [[ -f "$HOME/.supabase-skill.json" ]]; then
        eval "$(jq -r 'to_entries | .[] | "export SUPABASE_SKILL_" + (.key | gsub("-"; "_") | ascii_upcase) + "=\"" + (.value // "") + "\""' "$HOME/.supabase-skill.json" 2>/dev/null)"
    fi
    
    # Load from current directory (overrides home)
    if [[ -f ".supabase-skill.json" ]]; then
        eval "$(jq -r 'to_entries | .[] | "export SUPABASE_SKILL_" + (.key | gsub("-"; "_") | ascii_upcase) + "=\"" + (.value // "") + "\""' ".supabase-skill.json" 2>/dev/null)"
    fi
    
    # Map to standard Supabase environment variables
    [[ -n "${SUPABASE_SKILL_ACCESS_TOKEN:-}" ]] && export SUPABASE_ACCESS_TOKEN="$SUPABASE_SKILL_ACCESS_TOKEN"
    [[ -n "${SUPABASE_SKILL_PROJECT_REF:-}" ]] && export SUPABASE_PROJECT_REF="$SUPABASE_SKILL_PROJECT_REF"
    [[ -n "${SUPABASE_SKILL_DB_PASSWORD:-}" ]] && export SUPABASE_DB_PASSWORD="$SUPABASE_SKILL_DB_PASSWORD"
    [[ -n "${SUPABASE_SKILL_DB_URL:-}" ]] && export SUPABASE_DB_URL="$SUPABASE_SKILL_DB_URL"
    
    return 0
}

# Get a specific config value
get_config() {
    local key="$1"
    local default="$2"
    local value=""
    
    if command -v jq &> /dev/null; then
        # Check project config first
        if [[ -f ".supabase-skill.json" ]]; then
            value=$(jq -r ".[\"$key\"] // empty" ".supabase-skill.json" 2>/dev/null)
        fi
        
        # Fall back to home config
        if [[ -z "$value" ]] && [[ -f "$HOME/.supabase-skill.json" ]]; then
            value=$(jq -r ".[\"$key\"] // empty" "$HOME/.supabase-skill.json" 2>/dev/null)
        fi
    fi
    
    echo "${value:-$default}"
}

# Get the appropriate --project-ref flag if configured
get_project_flag() {
    local ref="${SUPABASE_SKILL_PROJECT_REF:-${SUPABASE_PROJECT_REF:-}}"
    if [[ -n "$ref" ]]; then
        echo "--project-ref $ref"
    fi
}

# Get the appropriate target flag (--local, --linked, or --db-url)
get_target_flag() {
    local default="${1:---local}"
    
    # If DB URL is set, use it
    if [[ -n "${SUPABASE_SKILL_DB_URL:-}" ]]; then
        echo "--db-url $SUPABASE_SKILL_DB_URL"
        return
    fi
    
    # If default-target is configured
    local target=$(get_config "default-target" "")
    case "$target" in
        local)
            echo "--local"
            ;;
        linked|remote)
            echo "--linked"
            ;;
        *)
            echo "$default"
            ;;
    esac
}

# Auto-load config when this script is sourced
load_supabase_config
