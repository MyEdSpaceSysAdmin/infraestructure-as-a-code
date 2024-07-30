resource "google_bigquery_dataset" "terraform_test" {
  dataset_id                  = "terraform_test"
  project                     = "${var.project}"
  location                    = var.default_region
  friendly_name               = "terraform_test"
  description                 = "dataset to test de terraform deployment"
  access {
    role          = "roles/bigquery.dataOwner"
    user_by_email = "bigquery-onwer@my-edspace-uat.iam.gserviceaccount.com"
  }
}
