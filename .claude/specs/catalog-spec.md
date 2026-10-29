# Specification: Product Catalog

## Workflow
- Work through the tasks in order
- Tasks 1 and 3: propose a plan first, implement only after I approve it
- Task 2: no plan needed, implement directly
- Start the next task only after the previous one is implemented and verified
- Follow CLAUDE.md and .claude/rules (TypeScript) for all tasks

---

## Task 1: CatalogService (service layer)

### Context
- Data model in @db/*.cds: Products, Suppliers, Reviews, Categories, ProductStatus
- Explore the project, then propose a plan

### Service
- CatalogService at /catalog
- Products: draft-enabled; Reviews are edited as part of the product draft
- Suppliers, Categories, ProductStatus: read-only

### Derived fields
- Products.isLowStock: true when stock < 10
- Products.stockCriticality: 1 when low stock, 3 otherwise
- Products.averageRating (1 decimal) and reviewCount, based on active reviews;
  computed for the whole result set in one query, no per-row queries
- Suppliers.location: "<city> (<country code>)", e.g. "Munich (DE)"

### Action: restock(quantity: Integer) on Products
- quantity must be > 0
- Increases stock and returns the updated product
- Not allowed while the product is being edited (draft)

### Validation
- Products: price must be > 0 (error shown on the price field)
- Reviews: rating 1–5 and reviewer name mandatory; enforce via model
  annotations where possible, handler only if needed

### Tests
- restock: valid quantity increases stock; quantity <= 0 rejected
- price <= 0 rejected on create and on draft activation
- review with rating outside 1–5 rejected
- averageRating/reviewCount correct with and without reviews
- isLowStock/stockCriticality correct at the boundary (stock 9 vs 10)

### Acceptance criteria
- `cds watch`, `npx tsc --noEmit` all pass
- All CSVs load; endpoints return the derived fields

### Expected plan output
1. Files to create or modify
2. Implementation order
3. Assumptions and open questions
4. Risks

---

## Task 2: HTTP test file (test/catalog-service.http)

### Prerequisite
- Task 1 implemented and verified

### Scope
- Requests for every entity and action: reads with $expand/$filter
- Draft flow for Products: create draft, patch, activate
- restock: valid quantity and quantity 0
- Negative cases: price 0, rating 6
- Variables for the base URL and IDs taken from the CSV mock data

### Acceptance criteria
- Run each request against `cds watch`; fix any that fail
- Negative cases return the expected errors

---

## Task 3: Refine Products Fiori app (app/products)

### Prerequisite
- Tasks 1 and 2 implemented and verified

### Context
- App generated with the SAP Fiori generator: List Report, OData V4,
  TypeScript, CatalogService, Products with navigation to reviews
- Do not regenerate or restructure the app
- Propose a plan first

### List Report
- Filters: category, supplier
- Columns: name, category, supplier, price, stock, low-stock indicator
  (with criticality), average rating as stars, status
- Restock button in the table toolbar

### Object Page
- Header: product name and category; stock with criticality, price,
  average rating as stars with review count
- Sections:
  - General Information: name, description, category, status
  - Pricing & Stock: price, stock, low-stock indicator
  - Supplier (read-only): name, email, location
  - Reviews: table with rating (stars), comment, reviewer, date;
    reviews can be added and edited in edit mode
- Restock button in the header

### Acceptance criteria (Claude verifies)
- `cds compile db srv app` passes
- App opens from the `cds watch` index page
- All UI text comes from i18n (_i18n or webapp/i18n)

### Acceptance criteria (manual check in the browser)
- Filters, columns, sections, and criticality work as specified
- Restock refreshes stock, low-stock indicator, and criticality on screen
- Restock is not available while editing
- Saving with price 0 shows an error on the price field
- A new review appears in the table and updates the average after saving

### Expected plan output
1. Annotation changes per file
2. Any manifest.json changes, with the reason
3. Open questions
