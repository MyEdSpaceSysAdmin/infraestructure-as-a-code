resource "google_bigquery_dataset" "standard_dataset" {
  dataset_id                  = "${var.env}_${var.dataset_name}"
  project                     = var.project
  location                    = var.default_region
  description                 = "Data Warehouse BigQuery dataset"
  access {
    role          = "roles/bigquery.dataOwner"
    user_by_email = "${var.env}-bigquery-owner@${var.project}.iam.gserviceaccount.com"
  }
  access {
    role          = "roles/bigquery.dataOwner"
    user_by_email = "${var.env}-cloud-composer-env-sa@${var.project}.iam.gserviceaccount.com"
  }

  lifecycle {
    prevent_destroy = true
  }
}
