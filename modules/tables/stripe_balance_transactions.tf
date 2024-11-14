locals {
  balance_transactions_schema = [
    { name = "id", type = "STRING", mode = "NULLABLE"}, 
    { name = "object", type = "STRING", mode = "NULLABLE"}, 
    { name = "amount", type = "INTEGER", mode = "NULLABLE"}, 
    { name = "available_on", type = "INTEGER", mode = "NULLABLE"}, 
    { name = "created", type = "INTEGER", mode = "NULLABLE"}, 
    { name = "currency", type = "STRING", mode = "NULLABLE"}, 
    { name = "description", type = "STRING", mode = "NULLABLE"}, 
    { name = "exchange_rate", type = "INTEGER", mode = "NULLABLE"}, 
    { name = "fee", type = "INTEGER", mode = "NULLABLE"}, 
    { name = "fee_details", type = "STRUCT", mode = "NULLABLE"}, 
    { name = "net", type = "INTEGER", mode = "NULLABLE"}, 
    { name = "reporting_category", type = "STRING", mode = "NULLABLE"}, 
    { name = "source", type = "STRING", mode = "NULLABLE"}, 
    { name = "status", type = "STRING", mode = "NULLABLE"}, 
    { name = "type", type = "STRING", mode = "NULLABLE"},
  ]
}

variable "tables" {
  default = [
    {
      table_name = "balance_transactions"
      schema     = local.balance_transactions_schema
    }
  ]
}
