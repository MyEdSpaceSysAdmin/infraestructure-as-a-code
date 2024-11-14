locals {
  coupons_schema = [
    { name = "id", type = "STRING", mode = "NULLABLE" }, 
    { name = "object", type = "STRING", mode = "NULLABLE" }, 
    { name = "amount_off", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "created", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "currency", type = "STRING", mode = "NULLABLE" }, 
    { name = "duration", type = "STRING", mode = "NULLABLE" }, 
    { name = "duration_in_months", type = "INT", mode = "NULLABLE" }, 
    { name = "livemode", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "max_redemptions", type = "INT", mode = "NULLABLE" }, 
    { name = "name", type = "STRING", mode = "NULLABLE" }, 
    { name = "percent_off", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "redeem_by", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "times_redeemed", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "valid", type = "INTEGER", mode = "NULLABLE" }
  ]
}

variable "tables" {
  default = [
    {
      table_name = "coupons"
      schema     = local.coupons_schema
    }
  ]
}
