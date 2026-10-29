using com.valantic.claude.inventory as inventory from '../db/schema';

service CatalogService @(path: '/catalog') {

  @odata.draft.enabled
  entity Products as
    projection on inventory.Products {
      *,
      (stock < 10) as isLowStock : Boolean,
      case when stock < 10 then 1 else 3 end as stockCriticality : Integer,
      virtual null as averageRating : Decimal(2, 1),
      virtual null as reviewCount : Integer
    }
    actions {
      action restock(quantity : Integer) returns Products;
    };

  entity Reviews as projection on inventory.Reviews;

  @readonly
  entity Suppliers as
    projection on inventory.Suppliers {
      *,
      city || ' (' || country.code || ')' as location : String(60)
    };

  @readonly
  entity Categories as projection on inventory.Categories;

  @readonly
  entity ProductStatus as projection on inventory.ProductStatus;
}
