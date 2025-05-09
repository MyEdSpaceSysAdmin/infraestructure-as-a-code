locals {
  hightouch_reverse_etl_required_roles = [
    "roles/bigquery.user",
    "roles/bigquery.dataViewer",
  ]
}

resource "google_service_account" "hightouch_reverse_etl_service_account" {
  account_id   = "${var.env}-hightouch-reverse-etl-sa"
  display_name = "Service account for ${var.env} Hightouch Reverse ETL"
}

resource "google_project_iam_member" "hightouch_reverse_etl_service_account" {
  for_each = toset(local.hightouch_reverse_etl_required_roles)
  project  = var.project
  member   = "serviceAccount:${google_service_account.hightouch_reverse_etl_service_account.email}"
  role     = each.key
}

module "hightouch_audit_dataset" {
  source         = "../../modules/dataset"
  project        = var.project
  dataset_name   = "hightouch_audit"
  default_region = var.region
}

module "hightouch_planner_dataset" {
  source         = "../../modules/dataset"
  project        = var.project
  dataset_name   = "hightouch_planner"
  default_region = var.region
}

resource "google_bigquery_dataset_access" "hightouch_audit_data_editor" {
  dataset_id = module.hightouch_audit_dataset.dataset_id
  project    = var.project

  role          = "roles/bigquery.dataEditor"
  user_by_email = google_service_account.hightouch_reverse_etl_service_account.email
}

resource "google_bigquery_dataset_access" "hightouch_audit_data_viewer" {
  dataset_id = module.hightouch_audit_dataset.dataset_id
  project    = var.project

  role          = "roles/bigquery.dataViewer"
  user_by_email = google_service_account.hightouch_reverse_etl_service_account.email
}

resource "google_bigquery_dataset_access" "hightouch_planner_data_editor" {
  dataset_id = module.hightouch_planner_dataset.dataset_id
  project    = var.project

  role          = "roles/bigquery.dataEditor"
  user_by_email = google_service_account.hightouch_reverse_etl_service_account.email
}

resource "google_bigquery_dataset_access" "hightouch_planner_data_viewer" {
  dataset_id = module.hightouch_planner_dataset.dataset_id
  project    = var.project

  role          = "roles/bigquery.dataViewer"
  user_by_email = google_service_account.hightouch_reverse_etl_service_account.email
}