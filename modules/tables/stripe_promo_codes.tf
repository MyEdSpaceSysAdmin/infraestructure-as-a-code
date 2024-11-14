locals {
  promo_codes_schema = [
    { name = "id", type = "STRING", mode = "NULLABLE" }, 
    { name = "object", type = "STRING", mode = "NULLABLE" }, 
    { name = "active", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "code", type = "STRING", mode = "NULLABLE" }, 
    { name = "created", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "customer", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "expires_at", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "livemode", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "max_redemptions", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "times_redeemed", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "coupon.id", type = "STRING", mode = "NULLABLE" }, 
    { name = "coupon.object", type = "STRING", mode = "NULLABLE" }, 
    { name = "coupon.amount_off", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "coupon.created", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "coupon.currency", type = "STRING", mode = "NULLABLE" }, 
    { name = "coupon.duration", type = "STRING", mode = "NULLABLE" }, 
    { name = "coupon.duration_in_months", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "coupon.livemode", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "coupon.max_redemptions", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "coupon.name", type = "STRING", mode = "NULLABLE" }, 
    { name = "coupon.percent_off", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "coupon.redeem_by", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "coupon.times_redeemed", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "coupon.valid", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "restrictions.first_time_transaction", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "restrictions.minimum_amount", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "restrictions.minimum_amount_currency", type = "INTEGER", mode = "NULLABLE" }
  ]
}

variable "tables" {
  default = [
    {
      table_name = "promo_codes"
      schema     = local.promo_codes_schema
    }
  ]
}
