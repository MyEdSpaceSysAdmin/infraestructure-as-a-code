locals {
  charges_schema = [
    { name = "id", type = "STRING", mode = "NULLABLE" }, 
    { name = "object", type = "STRING", mode = "NULLABLE" }, 
    { name = "amount", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "amount_captured", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "amount_refunded", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "application", type = "STRING", mode = "NULLABLE" }, 
    { name = "application_fee", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "application_fee_amount", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "balance_transaction", type = "STRING", mode = "NULLABLE" }, 
    { name = "calculated_statement_descriptor", type = "STRING", mode = "NULLABLE" }, 
    { name = "captured", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "created", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "currency", type = "STRING", mode = "NULLABLE" }, 
    { name = "customer", type = "STRING", mode = "NULLABLE" }, 
    { name = "description", type = "STRING", mode = "NULLABLE" }, 
    { name = "destination", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "dispute", type = "STRING", mode = "NULLABLE" }, 
    { name = "disputed", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "failure_balance_transaction", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "failure_code", type = "STRING", mode = "NULLABLE" }, 
    { name = "failure_message", type = "STRING", mode = "NULLABLE" }, 
    { name = "invoice", type = "STRING", mode = "NULLABLE" }, 
    { name = "livemode", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "on_behalf_of", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "order", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "paid", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "payment_intent", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method", type = "STRING", mode = "NULLABLE" }, 
    { name = "receipt_email", type = "STRING", mode = "NULLABLE" }, 
    { name = "receipt_number", type = "STRING", mode = "NULLABLE" }, 
    { name = "receipt_url", type = "STRING", mode = "NULLABLE" }, 
    { name = "refunded", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "review", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "shipping", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "source", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source_transfer", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "statement_descriptor", type = "STRING", mode = "NULLABLE" }, 
    { name = "statement_descriptor_suffix", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "status", type = "STRING", mode = "NULLABLE" }, 
    { name = "transfer_data", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "transfer_group", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "billing_details.address.city", type = "STRING", mode = "NULLABLE" }, 
    { name = "billing_details.address.country", type = "STRING", mode = "NULLABLE" }, 
    { name = "billing_details.address.line1", type = "STRING", mode = "NULLABLE" }, 
    { name = "billing_details.address.line2", type = "STRING", mode = "NULLABLE" }, 
    { name = "billing_details.address.postal_code", type = "STRING", mode = "NULLABLE" }, 
    { name = "billing_details.address.state", type = "STRING", mode = "NULLABLE" }, 
    { name = "billing_details.email", type = "STRING", mode = "NULLABLE" }, 
    { name = "billing_details.name", type = "STRING", mode = "NULLABLE" }, 
    { name = "billing_details.phone", type = "STRING", mode = "NULLABLE" }, 
    { name = "outcome.network_status", type = "STRING", mode = "NULLABLE" }, 
    { name = "outcome.reason", type = "STRING", mode = "NULLABLE" }, 
    { name = "outcome.risk_level", type = "STRING", mode = "NULLABLE" }, 
    { name = "outcome.seller_message", type = "STRING", mode = "NULLABLE" }, 
    { name = "outcome.type", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.amount_authorized", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.authorization_code", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.brand", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.checks.address_line1_check", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.checks.address_postal_code_check", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.checks.cvc_check", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.country", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.exp_month", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.exp_year", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.extended_authorization.status", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.fingerprint", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.funding", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.incremental_authorization.status", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.installments", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.last4", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.mandate", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.multicapture.status", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.network", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.network_token.used", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.overcapture.maximum_amount_capturable", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.overcapture.status", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.three_d_secure", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.wallet", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "payment_method_details.type", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.three_d_secure.authentication_flow", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.three_d_secure.electronic_commerce_indicator", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.three_d_secure.exemption_indicator", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.three_d_secure.result", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.three_d_secure.result_reason", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.three_d_secure.transaction_id", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.three_d_secure.version", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.wallet.dynamic_last4", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.wallet.type", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.wallet.apple_pay.type", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.paypal.country", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.paypal.payer_email", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.paypal.payer_id", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.paypal.payer_name", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.paypal.seller_protection.dispute_categories", type = "STRING", mode = "NULLABLE"},
    { name = "payment_method_details.paypal.seller_protection.status", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.paypal.transaction_id", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.bacs_debit.fingerprint", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.bacs_debit.last4", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.bacs_debit.mandate", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.bacs_debit.sort_code", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.link.country", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.id", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.object", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.amount", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.card.address_line1_check", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.card.address_zip_check", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.card.brand", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.card.country", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.card.cvc_check", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.card.dynamic_last4", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.card.exp_month", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.card.exp_year", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.card.fingerprint", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.card.funding", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.card.last4", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.card.name", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.card.three_d_secure", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.card.tokenization_method", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.client_secret", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.created", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.currency", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.customer", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.flow", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.livemode", type = "INTEGER", mode = "NULLABLE" }, 
    { name = "source.owner.address", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.owner.email", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.owner.name", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.owner.phone", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.owner.verified_address", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.owner.verified_email", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.owner.verified_name", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.owner.verified_phone", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.statement_descriptor", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.status", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.type", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.usage", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.card.capture_before", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.address_city", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.address_country", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.address_line1", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.address_line1_check", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.address_line2", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.address_state", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.address_zip", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.address_zip_check", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.brand", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.country", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.cvc_check", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.dynamic_last4", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.exp_month", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.exp_year", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.fingerprint", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.funding", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.last4", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.name", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.tokenization_method", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.wallet", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "fraud_details.stripe_report", type = "STRING", mode = "NULLABLE" }, 
    { name = "outcome.rule", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.klarna.payer_details.address.country", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.klarna.payment_method_category", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.klarna.preferred_locale", type = "STRING", mode = "NULLABLE" }, 
    { name = "payment_method_details.klarna.payer_details", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "outcome", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "source.owner.address.city", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.owner.address.country", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.owner.address.line1", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.owner.address.line2", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.owner.address.postal_code", type = "STRING", mode = "NULLABLE" }, 
    { name = "source.owner.address.state", type = "FLOAT", mode = "NULLABLE" }, 
    { name = "metadata.invoiceid", type = "STRING", mode = "NULLABLE" }, 
    { name = "metadata.projectid", type = "STRING", mode = "NULLABLE" }
  ]
}

variable "tables" {
  default = [
    {
      table_name = "charges"
      schema     = local.charges_schema
    }
  ]
}
