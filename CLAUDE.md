# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

SAP CAP (Cloud Application Programming Model) Node.js project in TypeScript (`@sap/cds` ^10, SQLite via `@cap-js/sqlite` for local dev). Currently only the data layer exists: `srv/` and `app/` are empty, and there are no tests or lint config.

## Commands

- `cds watch` — run the app locally with live reload (also a VS Code task in `.vscode/tasks.json`). Uses in-memory SQLite and auto-loads the CSVs in `db/data/`.
- `cds compile db/schema.cds --to sql` — check the model compiles / inspect generated SQL.
- `cds-typer` (`@cap-js/cds-typer`) generates types into `@cds-models/`, imported via the `#cds-models/*` alias (see `package.json` `imports` and `tsconfig.json` `paths`).

## Architecture

- `db/schema.cds` — single domain model, namespace `com.valantic.claude.inventory`. Entities: `Suppliers` and `Products` (both `cuid` + `managed`, with `modifiedAt` as `@odata.etag`), and code lists `Categories` (key `String(2)`) and `ProductStatus` (key `String(1)`, `Products.status` defaults to `'A'`). `Category`/`Status` are association types to those code lists.
- `db/data/<namespace>-<Entity>.csv` — seed data. Semicolon-separated, header row required, filename must be `com.valantic.claude.inventory-<Entity>.csv`. Foreign keys (supplier UUIDs, category/status codes) must reference existing rows.
- `prompts/*.md` — the prompts used to generate the project, schema and mock data (the project is built iteratively via prompts). `prompts/edit_schema.md` (untracked) requests a `Reviews` entity (`rating` Integer with `@assert.range: [1, 5]`, `comment` String(1024), `product` association to `Products`) and says to STOP and ask on merge conflicts during pull.

## Structure
- db/   → CDS data model (db/*.cds) and mock data (db/data/*.csv)
- srv/  → service definitions (.cds) and handlers (.ts)
- app/  → Fiori Elements apps, annotations, i18n
- test/ → .http requests and Jest tests (cds.test)

## How we work
- Read existing files first and follow their patterns, namespace, and naming
- Generated files (Fiori generator output) are not restructured unless asked
- For non-trivial changes, state assumptions; ask if requirements are ambiguous
- Layer-specific conventions live in .claude/rules/
