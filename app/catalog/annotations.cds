using CatalogService as service from '../../srv/catalog-service';

// ---------------------------------------------------------------------------
// Products
// ---------------------------------------------------------------------------
annotate service.Products with @(
  UI.HeaderInfo              : {
    TypeName      : '{i18n>product}',
    TypeNamePlural: '{i18n>products}',
    Title         : {
      $Type: 'UI.DataField',
      Value: name
    },
    Description   : {
      $Type: 'UI.DataField',
      Value: category_code
    }
  },

  UI.SelectionFields         : [
    category_code,
    supplier_ID
  ],

  UI.LineItem                : [
    {
      $Type : 'UI.DataFieldForAction',
      Action: 'CatalogService.restock',
      Label : '{i18n>actionRestock}'
    },
    {
      $Type: 'UI.DataField',
      Value: name
    },
    {
      $Type: 'UI.DataField',
      Value: category_code
    },
    {
      $Type: 'UI.DataField',
      Value: supplier_ID
    },
    {
      $Type: 'UI.DataField',
      Value: price
    },
    {
      $Type      : 'UI.DataField',
      Value      : stock,
      Criticality: stockCriticality
    },
    {
      $Type      : 'UI.DataField',
      Value      : isLowStock,
      Criticality: stockCriticality
    },
    {
      $Type : 'UI.DataFieldForAnnotation',
      Target: '@UI.DataPoint#averageRating',
      Label : '{i18n>averageRating}'
    },
    {
      $Type: 'UI.DataField',
      Value: status_code
    }
  ],

  UI.DataPoint #averageRating: {
    Value        : averageRating,
    Title        : '{i18n>averageRating}',
    Visualization: #Rating,
    TargetValue  : 5
  },

  UI.DataPoint #stock        : {
    Value      : stock,
    Title      : '{i18n>stock}',
    Criticality: stockCriticality
  },

  UI.DataPoint #price        : {
    Value: price,
    Title: '{i18n>price}'
  },

  UI.DataPoint #reviewCount  : {
    Value: reviewCount,
    Title: '{i18n>reviewCount}'
  },

  UI.HeaderFacets            : [
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'HeaderStock',
      Target: '@UI.DataPoint#stock'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'HeaderPrice',
      Target: '@UI.DataPoint#price'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'HeaderRating',
      Target: '@UI.DataPoint#averageRating'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'HeaderReviewCount',
      Target: '@UI.DataPoint#reviewCount'
    }
  ],

  UI.Identification          : [{
    $Type : 'UI.DataFieldForAction',
    Action: 'CatalogService.restock',
    Label : '{i18n>actionRestock}'
  }],

  UI.FieldGroup #General     : {
    $Type: 'UI.FieldGroupType',
    Data : [
      {
        $Type: 'UI.DataField',
        Value: name
      },
      {
        $Type: 'UI.DataField',
        Value: description
      },
      {
        $Type: 'UI.DataField',
        Value: category_code
      },
      {
        $Type: 'UI.DataField',
        Value: status_code
      }
    ]
  },

  UI.FieldGroup #PricingStock: {
    $Type: 'UI.FieldGroupType',
    Data : [
      {
        $Type: 'UI.DataField',
        Value: price
      },
      {
        $Type      : 'UI.DataField',
        Value      : stock,
        Criticality: stockCriticality
      },
      {
        $Type      : 'UI.DataField',
        Value      : isLowStock,
        Criticality: stockCriticality
      }
    ]
  },

  UI.FieldGroup #Supplier    : {
    $Type: 'UI.FieldGroupType',
    Data : [
      {
        $Type: 'UI.DataField',
        Value: supplier.name
      },
      {
        $Type: 'UI.DataField',
        Value: supplier.email
      },
      {
        $Type: 'UI.DataField',
        Value: supplier.location
      }
    ]
  },

  UI.Facets                  : [
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'GeneralFacet',
      Label : '{i18n>sectionGeneral}',
      Target: '@UI.FieldGroup#General'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'PricingStockFacet',
      Label : '{i18n>sectionPricingStock}',
      Target: '@UI.FieldGroup#PricingStock'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'SupplierFacet',
      Label : '{i18n>sectionSupplier}',
      Target: '@UI.FieldGroup#Supplier'
    },
    {
      $Type : 'UI.ReferenceFacet',
      ID    : 'ReviewsFacet',
      Label : '{i18n>sectionReviews}',
      Target: 'reviews/@UI.LineItem'
    }
  ]
);

annotate service.Products with {
  name          @title: '{i18n>productName}';
  description   @title: '{i18n>description}';
  price         @title                 : '{i18n>price}'     @Measures.ISOCurrency: currency_code;
  stock         @title: '{i18n>stock}';
  isLowStock    @title                 : '{i18n>lowStock}'  @Common.FieldControl : #ReadOnly;
  averageRating @title: '{i18n>averageRating}';
  reviewCount   @title: '{i18n>reviewCount}';
  category      @title                 : '{i18n>category}'
                @Common.Text           : category.name
                @Common.TextArrangement: #TextOnly;
  status        @title                 : '{i18n>status}'
                @Common.Text           : status.name
                @Common.TextArrangement: #TextOnly;
  supplier      @title                 : '{i18n>supplier}'
                @Common.Text           : supplier.name
                @Common.TextArrangement: #TextOnly
                @Common.ValueList      : {
    $Type         : 'Common.ValueListType',
    CollectionPath: 'Suppliers',
    Parameters    : [
      {
        $Type            : 'Common.ValueListParameterInOut',
        LocalDataProperty: supplier_ID,
        ValueListProperty: 'ID'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'name'
      },
      {
        $Type            : 'Common.ValueListParameterDisplayOnly',
        ValueListProperty: 'location'
      }
    ]
  };
};

// ---------------------------------------------------------------------------
// restock action
// ---------------------------------------------------------------------------
annotate service.Products actions {
  restock   @(
    Common.SideEffects     : {TargetProperties: [
      'in/stock',
      'in/isLowStock',
      'in/stockCriticality'
    ]},
    Core.OperationAvailable: {$edmJson: {$Path: 'in/IsActiveEntity'}}
  )
  (quantity @title: '{i18n>quantity}'
  );
};

// ---------------------------------------------------------------------------
// Suppliers (read-only field labels)
// ---------------------------------------------------------------------------
annotate service.Suppliers with {
  name     @title: '{i18n>supplierName}';
  email    @title: '{i18n>supplierEmail}';
  location @title: '{i18n>supplierLocation}';
};

// ---------------------------------------------------------------------------
// Reviews
// ---------------------------------------------------------------------------
annotate service.Reviews with @(
  UI.HeaderInfo               : {
    TypeName      : '{i18n>review}',
    TypeNamePlural: '{i18n>reviews}',
    Title         : {
      $Type: 'UI.DataField',
      Value: reviewer
    }
  },

  UI.DataPoint #rating        : {
    Value        : rating,
    Title        : '{i18n>rating}',
    Visualization: #Rating,
    TargetValue  : 5
  },

  UI.LineItem                 : [
    {
      $Type : 'UI.DataFieldForAnnotation',
      Target: '@UI.DataPoint#rating',
      Label : '{i18n>rating}'
    },
    {
      $Type: 'UI.DataField',
      Value: comment
    },
    {
      $Type: 'UI.DataField',
      Value: reviewer
    },
    {
      $Type: 'UI.DataField',
      Value: createdAt
    }
  ],

  UI.FieldGroup #ReviewDetails: {
    $Type: 'UI.FieldGroupType',
    Data : [
      {
        $Type: 'UI.DataField',
        Value: rating
      },
      {
        $Type: 'UI.DataField',
        Value: comment
      },
      {
        $Type: 'UI.DataField',
        Value: reviewer
      },
      {
        $Type: 'UI.DataField',
        Value: createdAt
      }
    ]
  },

  UI.Facets                   : [{
    $Type : 'UI.ReferenceFacet',
    ID    : 'ReviewDetailsFacet',
    Label : '{i18n>sectionReviewDetails}',
    Target: '@UI.FieldGroup#ReviewDetails'
  }]
);

annotate service.Reviews with {
  rating    @title: '{i18n>rating}';
  comment   @title: '{i18n>comment}';
  reviewer  @title: '{i18n>reviewer}';
  createdAt @title: '{i18n>reviewDate}';
};
