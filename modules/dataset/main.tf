resource "google_bigquery_dataset" "standard_dataset" {
  dataset_id                  = var.dataset_name
  project                     = var.project
  location                    = var.default_region
  description                 = ""

  lifecycle {
    prevent_destroy = true
  }
}
