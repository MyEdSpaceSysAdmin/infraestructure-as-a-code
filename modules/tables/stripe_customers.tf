locals {
  customers_schema = [
    { name = "id", type = "STRING", mode = "NULLABLE" },
    { name = "object", type = "STRING", mode = "NULLABLE" },
    { name = "balance", type = "INTEGER", mode = "NULLABLE" },
    { name = "created", type = "INTEGER", mode = "NULLABLE" },
    { name = "currency", type = "STRING", mode = "NULLABLE" },
    { name = "default_source", type = "STRING", mode = "NULLABLE" },
    { name = "delinquent", type = "BIT", mode = "NULLABLE" },
    { name = "description", type = "STRING", mode = "NULLABLE" },
    { name = "discount", type = "INTEGER", mode = "NULLABLE" },
    { name = "email", type = "STRING", mode = "NULLABLE" },
    { name = "invoice_prefix", type = "STRING", mode = "NULLABLE" },
    { name = "livemode", type = "BIT", mode = "NULLABLE" },
    { name = "name", type = "STRING", mode = "NULLABLE" },
    { name = "phone", type = "STRING", mode = "NULLABLE" },
    { name = "preferred_locales", type = "STRING", mode = "NULLABLE" },
    { name = "shipping", type = "FLOAT", mode = "NULLABLE" },
    { name = "tax_exempt", type = "STRING", mode = "NULLABLE" },
    { name = "test_clock", type = "INTEGER", mode = "NULLABLE" },
    { name = "address.city", type = "STRING", mode = "NULLABLE" },
    { name = "address.country", type = "STRING", mode = "NULLABLE" },
    { name = "address.line1", type = "STRING", mode = "NULLABLE" },
    { name = "address.line2", type = "STRING", mode = "NULLABLE" },
    { name = "address.postal_code", type = "STRING", mode = "NULLABLE" },
    { name = "address.state", type = "STRING", mode = "NULLABLE" },
    { name = "invoice_settings.custom_fields", type = "INTEGER", mode = "NULLABLE" },
    { name = "invoice_settings.default_payment_method", type = "STRING", mode = "NULLABLE" },
    { name = "invoice_settings.footer", type = "INTEGER", mode = "NULLABLE" },
    { name = "invoice_settings.rendering_options", type = "INTEGER", mode = "NULLABLE" },
    { name = "address", type = "FLOAT", mode = "NULLABLE" },
    { name = "shipping.address.city", type = "STRING", mode = "NULLABLE" },
    { name = "shipping.address.country", type = "STRING", mode = "NULLABLE" },
    { name = "shipping.address.line1", type = "STRING", mode = "NULLABLE" },
    { name = "shipping.address.line2", type = "STRING", mode = "NULLABLE" },
    { name = "shipping.address.postal_code", type = "STRING", mode = "NULLABLE" },
    { name = "shipping.address.state", type = "STRING", mode = "NULLABLE" },
    { name = "shipping.name", type = "STRING", mode = "NULLABLE" },
    { name = "shipping.phone", type = "STRING", mode = "NULLABLE" },
    { name = "metadata.utm_campaign", type = "STRING", mode = "NULLABLE" },
    { name = "metadata.utm_content", type = "STRING", mode = "NULLABLE" },
    { name = "metadata.utm_medium", type = "STRING", mode = "NULLABLE" },
    { name = "metadata.utm_source", type = "STRING", mode = "NULLABLE" },
    { name = "metadata.utm_term", type = "STRING", mode = "NULLABLE" }
  ]
}

variable "tables" {
  default = [
    {
      table_name = "customers"
      schema     = local.customers_schema
    }
  ]
}
