locals {
  prices_schema = [
    { name = "id", type = "STRING", mode = "NULLABLE" }, 
    { name = "object", type = "STRING", mode = "NULLABLE" }, 
    { name = "active", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "billing_scheme", type = "STRING", mode = "NULLABLE" }, 
    { name = "created", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "currency", type = "STRING", mode = "NULLABLE" }, 
    { name = "custom_unit_amount", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "livemode", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "lookup_key", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "nickname", type = "STRING", mode = "NULLABLE" }, 
    { name = "product", type = "STRING", mode = "NULLABLE" }, 
    { name = "tax_behavior", type = "STRING", mode = "NULLABLE" }, 
    { name = "tiers_mode", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "transform_quantity", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "type", type = "STRING", mode = "NULLABLE" }, 
    { name = "unit_amount", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "unit_amount_decimal", type = "STRING", mode = "NULLABLE" }, 
    { name = "recurring.aggregate_usage", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "recurring.interval", type = "STRING", mode = "NULLABLE" }, 
    { name = "recurring.interval_count", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "recurring.meter", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "recurring.trial_period_days", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "recurring.usage_type", type = "STRING", mode = "NULLABLE" }, 
    { name = "recurring", type = "FLOAT", mode = "NULLABLE" }
  ]
}

variable "tables" {
  default = [
    {
      table_name = "prices"
      schema     = local.prices_schema
    }
  ]
}
