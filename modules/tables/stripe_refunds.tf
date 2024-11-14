locals {
  refunds_schema = [
    { name = "id", type = "STRING", mode = "NULLABLE" }, 
    { name = "object", type = "STRING", mode = "NULLABLE" }, 
    { name = "amount", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "balance_transaction", type = "STRING", mode = "NULLABLE" }, 
    { name = "charge", type = "STRING", mode = "NULLABLE" }, 
    { name = "created", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "currency", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_intent", type = "STRING", mode = "NULLABLE" }, 
    { name = "reason", type = "STRING", mode = "NULLABLE" }, 
    { name = "receipt_number", type = "STRING", mode = "NULLABLE" }, 
    { name = "source_transfer_reversal", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "status", type = "STRING", mode = "NULLABLE" }, 
    { name = "transfer_reversal", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "destination_details.card.reference_status", type = "STRING", mode = "NULLABLE" }, 
    { name = "destination_details.card.reference_type", type = "STRING", mode = "NULLABLE" }, 
    { name = "destination_details.card.type", type = "STRING", mode = "NULLABLE" }, 
    { name = "destination_details.type", type = "STRING", mode = "NULLABLE" }, 
    { name = "destination_details.card.reference", type = "STRING", mode = "NULLABLE" }, 
    { name = "failure_balance_transaction", type = "STRING", mode = "NULLABLE" }, 
    { name = "failure_reason", type = "STRING", mode = "NULLABLE" }, 
    { name = "metadata.customer_id", type = "STRING", mode = "NULLABLE" }, 
    { name = "metadata.refund_id", type = "STRING", mode = "NULLABLE" }, 
    { name = "metadata.stripe_payment_link_id", type = "STRING", mode = "NULLABLE" }, 
    { name = "instructions_email", type = "STRING", mode = "NULLABLE" }, 
    { name = "destination_details.gb_bank_transfer.reference", type = "STRING", mode = "NULLABLE" }, 
    { name = "destination_details.gb_bank_transfer.reference_status", type = "STRING", mode = "NULLABLE" }
  ]
}

variable "tables" {
  default = [
    {
      table_name = "refunds"
      schema     = local.refunds_schema
    }
  ]
}
