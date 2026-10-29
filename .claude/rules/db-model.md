---
paths:
  - "db/**/*.cds"
---
# CDS data model conventions

- Use the namespace already declared in db/*.cds; don't introduce a new one
- Main entities use `cuid` and `managed`; never redeclare
  createdBy/createdAt/modifiedBy/modifiedAt
- Code lists extend `sap.common.CodeList` with a short String key (1–2 chars)
  and get a reusable type: `type X : Association to XCodes;`
- Annotate main entities with `modifiedAt @odata.etag`
- Children without their own lifecycle → `Composition of many ... on ... = $self`;
  independent entities → `Association`
- Mandatory business fields → `@mandatory`; numeric ranges → `@assert.range`
- Amounts → `Decimal(10,2)` + `currency: Currency`
- When an entity changes, update its CSV in db/data in the same task