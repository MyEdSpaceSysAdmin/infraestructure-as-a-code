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

# Teachfloor dataset and container tables
module "teachfloor_dataset" {
  source         = "../../modules/dataset"
  project        = var.project
  dataset_name   = "teachfloor"
  default_region = var.region
}


resource "google_bigquery_table" "courses_library_visit" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "courses_library_visit"
  deletion_protection = true

  time_partitioning {
    type = "DAY"
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/courses_library_visit.json")
}

resource "google_bigquery_table" "course_visit" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "course_visit"
  deletion_protection = true

  time_partitioning {
    type = "DAY"
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/course_visit.json")
}

resource "google_bigquery_table" "module_visit" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "module_visit"
  deletion_protection = true

  time_partitioning {
    type = "DAY"
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/module_visit.json")
}

resource "google_bigquery_table" "elements_visit" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "elements_visit"
  deletion_protection = true

  time_partitioning {
    type = "DAY"
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/elements_visit.json")
}

resource "google_bigquery_table" "start_quiz_module" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "start_quiz_module"
  deletion_protection = true
  time_partitioning {
    type = "DAY"
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/start_quiz_module.json")
}

resource "google_bigquery_table" "end_quiz_module" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "end_quiz_module"
  deletion_protection = true
  time_partitioning {
    type = "DAY"
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/end_quiz_module.json")
}

resource "google_bigquery_table" "course_enter" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "course_enter"
  deletion_protection = false
  time_partitioning {
    type = "DAY"
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/course_enter.json")
}

resource "google_bigquery_table" "course_leave" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "course_leave"
  deletion_protection = false
  time_partitioning {
    type = "DAY"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/course_leave.json")
}

resource "google_bigquery_table" "courses_enter" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "courses_enter"
  deletion_protection = false
  time_partitioning {
    type = "DAY"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/courses_enter.json")
}

resource "google_bigquery_table" "courses_leave" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "courses_leave"
  deletion_protection = false
  time_partitioning {
    type = "DAY"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/courses_leave.json")
}

resource "google_bigquery_table" "element_completed" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "element_completed"
  deletion_protection = false
  time_partitioning {
    type = "DAY"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/element_completed.json")
}

resource "google_bigquery_table" "element_enter" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "element_enter"
  deletion_protection = false
  time_partitioning {
    type = "DAY"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/element_enter.json")
}

resource "google_bigquery_table" "element_leave" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "element_leave"
  deletion_protection = false
  time_partitioning {
    type = "DAY"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/element_leave.json")
}

resource "google_bigquery_table" "identifies" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "identifies"
  deletion_protection = false
  time_partitioning {
    type = "DAY"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/identifies.json")
}

resource "google_bigquery_table" "login" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "login"
  deletion_protection = false
  time_partitioning {
    type = "DAY"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/login.json")
}

resource "google_bigquery_table" "module_enter" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "module_enter"
  deletion_protection = false
  time_partitioning {
    type = "DAY"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/module_enter.json")
}

resource "google_bigquery_table" "module_leave" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "module_leave"
  deletion_protection = false
  time_partitioning {
    type = "DAY"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/module_leave.json")
}

resource "google_bigquery_table" "pages" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "pages"
  deletion_protection = false
  time_partitioning {
    type = "DAY"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/pages.json")
}

resource "google_bigquery_table" "quiz_enter" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "quiz_enter"
  deletion_protection = false
  time_partitioning {
    type = "DAY"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/quiz_enter.json")
}

resource "google_bigquery_table" "tracks" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "tracks"
  deletion_protection = false
  time_partitioning {
    type = "DAY"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/tracks.json")
}

resource "google_bigquery_table" "users" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "users"
  deletion_protection = false
  time_partitioning {
    type = "DAY"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = file("${path.module}/bigquery_schemas/teachfloor/users.json")
}