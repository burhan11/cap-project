Create CSV files under @db/data for Categories, ProductStatus, Suppliers,
and Products (3–5 rows each), following the CAP naming convention
<namespace>-<Entity>.csv

IMPORTANT GUIDELINES:
- Use semicolon (;) as CSV separator (SAP CAP standard)
- First row must contain column headers
- Use UUID format consistently across related entities
- Ensure referential integrity (foreign keys must exist in parent entities)
- Use ISO 8601 format for all DateTime fields (YYYY-MM-DDTHH:mm:ssZ)
- Provide realistic, diverse, and culturally varied sample data