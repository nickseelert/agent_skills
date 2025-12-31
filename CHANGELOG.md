# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/).

## [Unreleased]

## [0.1.0] - 2025-12-30

### Added
- Initial release of Agent Skills repository
- **Supabase skill** - Full CLI integration for Supabase projects
  - Database operations (execute SQL, manage schemas, inspect tables)
  - Migration management (create, apply, rollback)
  - Edge Functions deployment and management
  - TypeScript type generation
  - Local development with Docker
  - Helper scripts (`execute-sql.sh`, `list-tables.sh`, `describe-table.sh`, `quick-query.sh`, `deploy-function.sh`, `generate-migration.sh`)
  - Templates for Edge Functions and migrations
  - CLI quick reference guide
- README.md with project documentation
- MIT License
- .gitignore with scalable patterns for skill config files
