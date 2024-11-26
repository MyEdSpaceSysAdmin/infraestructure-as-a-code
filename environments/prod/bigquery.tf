resource "google_service_account" "bigquery_user_service_account" {
  account_id   = "${var.env}-bigquery-owner"
  display_name = "Service account for generic BigQuery uses"
}

resource "google_project_iam_member" "bigquery_admin" {
  project = var.project
  role    = "roles/bigquery.admin"
  member  = "serviceAccount:${google_service_account.bigquery_user_service_account.email}"
  depends_on = [ google_service_account.bigquery_user_service_account ]
}

resource "google_project_iam_member" "bigquery_data_owner" {
  project = var.project
  role    = "roles/bigquery.dataOwner"
  member  = "serviceAccount:${google_service_account.bigquery_user_service_account.email}"
  depends_on = [ google_service_account.bigquery_user_service_account ]
}

module "dataset" {
  source  = "../../modules/dataset"
  project = var.project
  env     = local.env
  dataset_name = "data_warehouse"
  depends_on = [ google_project_iam_member.bigquery_admin, google_project_iam_member.bigquery_data_owner ]
}
