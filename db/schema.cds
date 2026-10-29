namespace com.valantic.claude.inventory;

using {
  sap,
  cuid,
  Currency,
  Country,
  managed
} from '@sap/cds/common';

// Code lists
entity Categories : sap.common.CodeList {
  key code : String(2); // Electronics, Furniture, Stationery, Groceries
}

entity ProductStatus : sap.common.CodeList {
  key code : String(1); // Available, Discontinued, OutOfStock
}

// Types
type Category : Association to Categories;
type Status   : Association to ProductStatus;

// Main entities
entity Suppliers : cuid, managed {
  name     : String(255) @mandatory;
  email    : String(255);
  phone    : String(30);
  country  : Country;
  city     : String(40);
  products : Association to many Products
               on products.supplier = $self;
}

entity Products : cuid, managed {
  name        : String(255)    @mandatory;
  description : String(1024);
  price       : Decimal(10, 2) @mandatory;
  currency    : Currency;
  stock       : Integer default 0;
  category    : Category;
  status      : Status default 'A';
  supplier    : Association to Suppliers;
  reviews     : Composition of many Reviews
                  on reviews.product = $self;
}

entity Reviews : cuid, managed {
  reviewer : String(100) @mandatory;
  rating  : Integer @mandatory  @assert.range: [1, 5];
  comment : String(1024);
  product : Association to Products;
}

annotate Suppliers with {
  modifiedAt @odata.etag
};

annotate Products with {
  modifiedAt @odata.etag
};

annotate Reviews with {
  modifiedAt @odata.etag
};
