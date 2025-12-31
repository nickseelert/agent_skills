# Agent Skills

A collection of curated skills for AI coding agents. Skills provide agents with specialized knowledge and tools to work effectively with specific technologies.

## What are Skills?

Skills are structured knowledge packages that help AI coding agents understand and interact with specific tools, services, and frameworks. Each skill includes:

- **Documentation** - Comprehensive guides and reference material
- **Helper Scripts** - Ready-to-use automation scripts
- **Templates** - Starter code and configuration files
- **Quick References** - Condensed command cheat sheets

## Available Skills

| Skill | Description |
|-------|-------------|
| [Supabase](./supabase/) | Interact with Supabase projects via CLI - database operations, migrations, Edge Functions, storage, and more |

## Getting Started

### Using Skills with AI Agents

Skills are designed to be loaded by AI coding agents that support external knowledge bases. Each skill's `SKILL.md` file contains the primary documentation in a format optimized for AI consumption.

### Manual Use

You can also use the helper scripts and templates directly:

```bash
# Example: Use Supabase skill scripts
cd supabase/scripts
./list-tables.sh
./quick-query.sh tables
```

## Skill Structure

Each skill follows a consistent structure:

```
skill-name/
├── SKILL.md              # Main skill documentation (AI-optimized)
├── scripts/              # Executable helper scripts
│   └── *.sh
├── templates/            # Starter templates and configs
│   └── *.json, *.sql, *.ts
└── references/           # Quick reference guides
    └── *.md
```

### SKILL.md Format

The `SKILL.md` file includes YAML frontmatter with metadata:

```yaml
---
name: skill-name
description: Brief description of what the skill enables
license: MIT
compatibility: Requirements and prerequisites
---
```

## Contributing

### Adding a New Skill

1. Create a new directory with the skill name
2. Add a `SKILL.md` file with comprehensive documentation
3. Include helper scripts in `scripts/`
4. Add useful templates in `templates/`
5. Create quick reference guides in `references/`

### Skill Guidelines

- **Self-contained** - Each skill should work independently
- **Comprehensive** - Cover the most common use cases
- **Practical** - Include working examples and scripts
- **Well-documented** - Clear explanations for both humans and AI agents

## Supabase Skill Highlights

The Supabase skill provides:

- **Database Operations** - Execute SQL, manage schemas, inspect tables
- **Migrations** - Create, apply, and manage database migrations
- **Edge Functions** - Deploy and manage serverless functions
- **Type Generation** - Generate TypeScript types from your schema
- **Local Development** - Full local stack with Docker
- **Helper Scripts** - Automation for common tasks

### Quick Start with Supabase

```bash
# 1. Install Supabase CLI
npm install -g supabase

# 2. Initialize project
supabase init
supabase start

# 3. Configure the skill
cp supabase/templates/supabase-skill.example.json .supabase-skill.json
# Edit .supabase-skill.json with your project details

# 4. Use helper scripts
./supabase/scripts/list-tables.sh
./supabase/scripts/quick-query.sh tables
```

See [supabase/SKILL.md](./supabase/SKILL.md) for full documentation.

## License

MIT License - See individual skills for their specific licenses.
