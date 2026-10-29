---
paths:
  - "app/**"
---

# Fiori Elements (OData V4) conventions

## Generated apps

- Apps are created with the SAP Fiori generator; do not regenerate or restructure them
- UI changes go into `app/<app>/annotations.cds`; explain any manifest.json
  change before making it
- Prefer annotations over custom code; extensions (controllers, fragments,
  building blocks) only when annotations can't do it, with a short reason

## Annotation style

- Annotate the service entity: `annotate <Service>.<Entity> with @(...)`
- Every displayed field, section, action, and action parameter has a label:
  `@title: '{i18n>key}'`
- Associations show text, not IDs:
  `@Common.Text: supplier.name` + `@Common.TextArrangement: #TextOnly`
- Value help: code lists provide it automatically; other associations
  get `@Common.ValueList`
- Amounts: `@Measures.ISOCurrency: currency_code`
- Read-only fields during editing: `@Common.FieldControl: #ReadOnly`
- Ratings: `UI.DataPoint` with `Visualization: #Rating` and `TargetValue: 5`

## List Report

- Filter fields via `UI.SelectionFields`
- Columns via `UI.LineItem` (DataField); status-like fields with `Criticality`
  pointing to an Integer field (0–3), never a Boolean

## Object Page

- `UI.HeaderInfo` is required (TypeName, TypeNamePlural, Title, Description)
- Sections via `UI.Facets` → ReferenceFacet to a `UI.FieldGroup`;
  every facet has an ID and an i18n label
- Composition children shown as a table section via `UI.LineItem` on the child

## Actions

- Table toolbar button → `UI.DataFieldForAction` in `UI.LineItem`;
  Object Page header button → in `UI.Identification`
- On draft-enabled entities, restrict actions to active instances:
  `@Core.OperationAvailable: { $edmJson: { $Path: 'in/IsActiveEntity' } }`
- Actions that change data declare side effects so the UI refreshes:
  `@Common.SideEffects: { TargetProperties: ['in/<field>', ...] }`

## i18n

- Labels used in .cds annotations → `_i18n/i18n.properties`
- App title/description (manifest) → `app/<app>/webapp/i18n/i18n.properties`
- Key names are descriptive and consistent (e.g. `productName`,
  `sectionSupplier`, `actionRestock`); no duplicate keys
- No hardcoded UI text anywhere

## TypeScript (extensions only)

- App was generated with TypeScript enabled; keep tsconfig.json and ui5.yaml
  (ui5-tooling-transpile) as generated
- Extensions live in `webapp/ext/` as .ts files, using ES imports:
  `import ControllerExtension from 'sap/ui/core/mvc/ControllerExtension'`
- Controller extensions are typed with the Fiori Elements ExtensionAPI;
  no `any`, use the UI5 types package already in package.json
- manifest.json references modules by their UI5 module path without the .ts extension

## Verification

- `cds compile db srv app` passes
- App opens from the `cds watch` index page without console errors