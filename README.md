# Agent Skills

A collection of curated skills for AI coding agents. Skills provide agents with specialized knowledge and tools to work effectively with specific technologies.

This repository follows the [Agent Skills standard](https://agentskills.io/specification).

## Available Skills

| Skill | Description |
|-------|-------------|
| [supabase](./supabase/) | Interact with Supabase projects via CLI - database operations, migrations, Edge Functions, storage, and more |

## Installation

Skills need to be installed in a location where your AI coding agent can discover them.

### For pi (pi-coding-agent)

**Option 1: Symlink entire repository (recommended)**

```bash
# Clone the repository
git clone https://github.com/yourusername/agent_skills.git ~/.pi/agent/skills/agent_skills

# Or symlink if you already have it cloned elsewhere
ln -s /path/to/agent_skills ~/.pi/agent/skills/agent_skills
```

Pi recursively searches `~/.pi/agent/skills/**/SKILL.md`, so all skills in this repo will be discovered.

**Option 2: Symlink individual skills**

```bash
# Symlink just the supabase skill
ln -s /path/to/agent_skills/supabase ~/.pi/agent/skills/supabase
```

**Option 3: Project-local skills**

```bash
# For project-specific use
ln -s /path/to/agent_skills/supabase .pi/skills/supabase
```

### For Claude Code

```bash
# User-level skills
ln -s /path/to/agent_skills/supabase ~/.claude/skills/supabase

# Or project-level
ln -s /path/to/agent_skills/supabase .claude/skills/supabase
```

### For Codex CLI

```bash
ln -s /path/to/agent_skills ~/.codex/skills/agent_skills
```

## Configuration

Some skills require configuration files with secrets (API keys, passwords, etc.). These follow the pattern `.<skill-name>-skill.json`.

Config files can be placed in two locations:
- **User global**: `~/.<skill-name>-skill.json` - applies to all projects
- **Project-specific**: `./<skill-name>-skill.json` - in your project root, overrides global

Example for Supabase:

```bash
# Option 1: Global config (applies to all your projects)
cp /path/to/agent_skills/supabase/templates/supabase-skill.example.json ~/.supabase-skill.json

# Option 2: Project-specific config (in your project directory)
cp /path/to/agent_skills/supabase/templates/supabase-skill.example.json ./.supabase-skill.json

# Then edit the file with your actual values
```

**Note**: These config files contain secrets and should never be committed. Add `.<skill-name>-skill.json` to your `.gitignore`.

## What are Skills?

Skills are self-contained capability packages that AI coding agents load on-demand. When the agent encounters a task matching a skill's description, it loads the skill documentation and gains access to specialized workflows, setup instructions, helper scripts, and reference material.

Each skill includes:

- **SKILL.md** - Primary documentation with frontmatter metadata
- **scripts/** - Executable helper scripts
- **templates/** - Starter code and configuration files  
- **references/** - Quick reference guides

### SKILL.md Format

```yaml
---
name: skill-name
description: When to use this skill (max 1024 chars, used for matching)
license: MIT
compatibility: Requirements and prerequisites
---

# Skill Name

Full documentation follows...
```

The `name` field must match the parent directory name.

## Manual Usage

You can also use the helper scripts and templates directly without an AI agent:

```bash
# Use Supabase skill scripts
./supabase/scripts/list-tables.sh
./supabase/scripts/quick-query.sh tables
./supabase/scripts/execute-sql.sh "SELECT * FROM users LIMIT 5"
```

## Contributing

### Adding a New Skill

1. Create a directory matching the skill name (lowercase, hyphens, max 64 chars)
2. Add a `SKILL.md` file with required frontmatter (`name`, `description`)
3. Include helper scripts in `scripts/`
4. Add templates in `templates/` (use `.example.json` for configs with secrets)
5. Add quick reference guides in `references/`

### Skill Guidelines

- **Self-contained** - Each skill should work independently
- **Comprehensive** - Cover the most common use cases
- **Practical** - Include working examples and scripts
- **Secure** - Never commit secrets; use `.example` config templates

## License

MIT License - See individual skills for their specific licenses.
