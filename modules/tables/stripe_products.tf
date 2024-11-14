locals {
  products_schema = [
    { name = "id", type = "STRING", mode = "NULLABLE" }, 
    { name = "object", type = "STRING", mode = "NULLABLE" }, 
    { name = "active", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "attributes", type = "STRING", mode = "NULLABLE" }, 
    { name = "created", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "default_price", type = "STRING", mode = "NULLABLE" }, 
    { name = "description", type = "STRING", mode = "NULLABLE" }, 
    { name = "images", type = "STRING", mode = "NULLABLE" },  
    { name = "livemode", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "marketing_features", type = "STRING", mode = "NULLABLE" },  
    { name = "name", type = "STRING", mode = "NULLABLE" }, 
    { name = "package_dimensions", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "shippable", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "statement_descriptor", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "tax_code", type = "STRING", mode = "NULLABLE" }, 
    { name = "type", type = "STRING", mode = "NULLABLE" }, 
    { name = "unit_label", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "updated", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "url", type = "INTEGER", mode = "NULLABLE" },
  ]
}

variable "tables" {
  default = [
    {
      table_name = "products"
      schema     = local.products_schema
    }
  ]
}
