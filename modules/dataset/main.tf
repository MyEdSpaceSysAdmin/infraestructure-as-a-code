resource "google_bigquery_dataset" "terraform-test" {
  dataset_id                  = "terraform-test"
  project                     = "${var.project}"
  location                    = var.region
  friendly_name               = "terraform-test"
  description                 = "dataset to test de terraform deployment"
  access {
    role          = "roles/bigquery.dataOwner"
    user_by_email = "bigquery-onwer@my-edspace-uat.iam.gserviceaccount.com"
  }
}