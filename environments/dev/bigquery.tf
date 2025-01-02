module "dataset" {
  source         = "../../modules/dataset"
  project        = var.project
  dataset_name   = "filament"
  default_region = var.region
}

# Note: Temporary resources only while google_ads_manager dataset is in the core-product-mes GCP project
module "google_ads_manager_dataset" {
  source         = "../../modules/dataset"
  project        = var.project
  dataset_name   = "google_ads_manager"
  default_region = var.region
}

resource "google_project_iam_member" "permissions" {
  project = var.project
  role    = "roles/iam.serviceAccountTokenCreator"
  member  = "serviceAccount:service-${var.project_number}@gcp-sa-bigquerydatatransfer.iam.gserviceaccount.com"
}

resource "google_service_account" "bq_schedule_queries_sa" {
  account_id   = "bq-scheduled-queries-sa"
  display_name = "Service Account for Scheduled Queries"
}

resource "google_project_iam_member" "bq_schedule_queries_sa" {
  project = var.project
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.bq_schedule_queries_sa.email}"
}

resource "google_project_iam_member" "bq_schedule_queries_sa_job_user" {
  project = var.project
  role    = "roles/bigquery.jobUser"
  member  = "serviceAccount:${google_service_account.bq_schedule_queries_sa.email}"
}

variable "google_ads_manager_tables" {
  type = list(string)
  default = [
    "ad_groups",
    "ad_performance_reports",
    "ads",
    "campaign_performance_reports",
    "campaigns",
    "click_performance_reports"
  ]
}

resource "google_bigquery_data_transfer_config" "query_config" {
  for_each = toset(var.google_ads_manager_tables)

  depends_on = [google_project_iam_member.permissions]

  display_name           = "scheduled_query_${each.value}"
  location               = var.region
  data_source_id         = "scheduled_query"
  schedule               = "every day 08:00"
  destination_dataset_id = "google_ads_manager"

  params = {
    destination_table_name_template = each.value
    write_disposition               = "WRITE_TRUNCATE"
    query                           = <<SQL
        SELECT
          *
        FROM 
          `core-product-mes.google_ads_manager.${each.value}_view`
    SQL
  }
}