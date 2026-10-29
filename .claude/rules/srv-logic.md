---
paths:
  - "srv/**"
---
# Service layer conventions (TypeScript)

## Structure
- Service definition and handler share a name: `srv/<name>-service.cds` + `srv/<name>-service.ts`
- Handlers use the class pattern with typed entities from cds-typer:
- Import entity types only from `#cds-models/...`; never edit @cds-models (generated)
- After changing any .cds file, regenerate types before writing handler code
- Services expose projections on db entities; business logic never goes into db/
- Read-only entities and code lists → `@readonly`

## TypeScript
- No `any`; use the generated types (singular = one row, plural = entity set)
- Virtual and optional fields are possibly undefined; handle them explicitly
- `npx tsc --noEmit` must pass

## Draft
- `@odata.draft.enabled` only on root entities; compositions follow automatically
- Validation must run on draft activation AND direct writes:
  `this.before(['SAVE', 'CREATE', 'UPDATE'], Entity, handler)`
- Defaults for new drafts → `this.before('NEW', Entity.drafts, ...)`

## Validation and messages
- Use `req.error({ status: 400, message: 'MSG_KEY', target: 'field' })`;
  use `req.reject` only to abort immediately
- Message texts in `_i18n/messages.properties` as UPPER_SNAKE keys

## Actions
- Bound actions declared in the service .cds inside `actions { }`
- Read keys from `req.params[0]`; validate parameters first
- Change values atomically: `UPDATE(Entity, ID).with({ stock: { '+=': quantity } })`
- Return the updated entity when the action `returns` it

## Virtual and calculated fields
- Pure expressions → CDS calculated element, no TS code
- Logic-based values → `virtual` field + `this.after('each', Entity, ...)`;
  guard against fields missing from $select
- UI criticality fields are Integer (0–3), never Boolean

## General
- Use cds.ql (SELECT/INSERT/UPDATE); no raw SQL strings
- Logging via `cds.log('<service>')`, not console.log
- Every new action or validation gets a Jest test (cds.test) and a test/*.http request