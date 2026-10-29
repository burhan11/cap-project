Create a SAP Cloud Application Programming Model (CAP) data model file
named schema.cds under @db folder with the following specifications:

NAMESPACE: com.valantic.claude.<schema_short_name>

IMPORTS:
- Import sap, cuid, Currency, Country, and managed from '@sap/cds/common'

CODE LIST ENTITIES (extending sap.common.CodeList):

1. Entity "Categories" with:
   - key code: String(2)
   - This will store values like Electronics, Furniture, Stationery, Groceries

2. Entity "ProductStatus" with:
   - key code: String(1)
   - This will store product statuses like Available, Discontinued, OutOfStock

TYPE DEFINITIONS:
- Category: Association to Categories
- Status: Association to ProductStatus

MAIN ENTITIES:

3. Entity "Suppliers" using cuid and managed:
   - name: String(255) with @mandatory annotation
   - email: String(255)
   - phone: String(30)
   - country: Country
   - city: String(40)
   - products: Association to many Products on products.supplier = $self
   - Annotate Suppliers entity with: modifiedAt @odata.etag

4. Entity "Products" using cuid and managed:
   - name: String(255) with @mandatory annotation
   - description: String(1024)
   - price: Decimal(10,2) with @mandatory annotation
   - currency: Currency
   - stock: Integer with default value 0
   - category: Category
   - status: Status with default value 'A'
   - supplier: Association to Suppliers
   - Annotate Products entity with: modifiedAt @odata.etag

VERIFY:
- Run `cds compile db/schema.cds` and fix any errors before finishing.