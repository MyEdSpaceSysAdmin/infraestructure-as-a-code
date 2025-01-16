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
  deletion_protection = false

  lifecycle {
    ignore_changes = [ # NOTE: For some reason the order of columns in the table schema gets changed when you load data into the tables
      schema           # Only remove this line or the whole lifecycle seciton if you intentionally change the schema and want to recreate the table
    ]
  }

  time_partitioning {
    type  = "DAY"
    field = "ingestion_date"
  }

  schema = <<EOF
[
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "number_of_courses",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "courses_id",
    "type": "STRING",
    "mode": "REPEATED"
  },
  {
    "name": "referring_url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "exit_url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "duration",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "notifications_clicked",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "profile_clicked",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "total_number_courses",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "total_courses_lib_visits",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "course_selected",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "ingestion_date",
    "type": "DATE",
    "mode": "NULLABLE"
  }
]
EOF
}

resource "google_bigquery_table" "course_visit" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "course_visit"
  deletion_protection = false

  time_partitioning {
    type  = "DAY"
    field = "ingestion_date"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = <<EOF
[
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_category",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_teacher",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_year_group",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "module_clicked",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "module_clicked_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "duration",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "module_element_clicked",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "module_element_clicked_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "curriculum_clicked",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "progress_clicked",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "number_of_modules_done",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "number_of_workbooks_done",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "number_of_livestreams_done",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "number_of_homework_done",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "number_of_video_solutions_done",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "number_of_modules",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "number_of_workbooks",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "number_of_homework",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "completed_course",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "number_of_livestreams",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "completed_courses",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "event_course_progress",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "user_course_progress",
    "type": "STRING",
    "mode": "REPEATED"
  },
  {
    "name": "user_quiz_avg_score",
    "type": "STRING",
    "mode": "REPEATED"
  },
  {
    "name": "ratio_of_homework_complete",
    "type": "STRING",
    "mode": "REPEATED"
  },
  {
    "name": "last_course_visited",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "total_course_hours",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "event_quiz_avg_score",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "ingestion_date",
    "type": "DATE",
    "mode": "NULLABLE"
  }
]
EOF
}

resource "google_bigquery_table" "module_visit" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "module_visit"
  deletion_protection = false

  time_partitioning {
    type  = "DAY"
    field = "ingestion_date"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = <<EOF
[
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_category",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_teacher",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_year_group",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "module_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "module_date",
    "type": "DATE",
    "mode": "NULLABLE"
  },
  {
    "name": "module_status",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "module_element_clicked",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "module_element_clicked_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "number_of_elements",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "number_of_elements_done",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "number_of_module_visits",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "ingestion_date",
    "type": "DATE",
    "mode": "NULLABLE"
  }
]
EOF
}

resource "google_bigquery_table" "elements_visit" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "elements_visit"
  deletion_protection = false

  time_partitioning {
    type  = "DAY"
    field = "ingestion_date"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = <<EOF
[
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "element_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "element_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "element_status",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_category",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_teacher",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_year_group",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "module_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "start_quiz_clicked",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "video_played",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "duration",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "downloaded_resource_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "download_resource",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "link_clicked",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "link_url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "marked_complete_clicked",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "timetable_clicked",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "ingestion_date",
    "type": "DATE",
    "mode": "NULLABLE"
  }
]
EOF
}

resource "google_bigquery_table" "start_quiz_module" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "start_quiz_module"
  deletion_protection = false
  time_partitioning {
    type  = "DAY"
    field = "ingestion_date"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = <<EOF
[
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "quiz_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "module_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "element_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "element_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_category",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_teacher",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_year_group",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "ingestion_date",
    "type": "DATE",
    "mode": "NULLABLE"
  }
]
EOF
}

resource "google_bigquery_table" "end_quiz_module" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "end_quiz_module"
  deletion_protection = false
  time_partitioning {
    type  = "DAY"
    field = "ingestion_date"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = <<EOF
[
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "quiz_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "module_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "element_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "number_of_questions",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "quiz_n_right",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "quiz_n_wrong",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "course_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_category",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_teacher",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "course_year_group",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "total_number_right_q",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "total_number_wrong_q",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "quiz_score",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "total_quizzes_completed",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "ingestion_date",
    "type": "DATE",
    "mode": "NULLABLE"
  }
]
EOF
}

resource "google_bigquery_table" "course_enter" {
  dataset_id          = module.teachfloor_dataset.dataset_id
  table_id            = "course_enter"
  deletion_protection = false
  time_partitioning {
    type = "DAY"
  }

  lifecycle {
    ignore_changes = [
      schema
    ]
  }

  schema = <<EOF
[
    {
        "name": "anonymous_id",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_course_availability",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_course_cover",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_course_created_at",
        "type": "TIMESTAMP",
        "mode": "NULLABLE"
    },
    {
        "name": "context_course_currency",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_course_id",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_course_name",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_course_object",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_course_visibility",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_element_created_at",
        "type": "TIMESTAMP",
        "mode": "NULLABLE"
    },
    {
        "name": "context_element_id",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_element_object",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_element_position",
        "type": "INTEGER",
        "mode": "NULLABLE"
    },
    {
        "name": "context_element_type",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_ip",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_library_name",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_library_version",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_locale",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_module_created_at",
        "type": "TIMESTAMP",
        "mode": "NULLABLE"
    },
    {
        "name": "context_module_id",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_module_name",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_module_object",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_module_position",
        "type": "INTEGER",
        "mode": "NULLABLE"
    },
    {
        "name": "context_module_type",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_page_path",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_page_referrer",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_page_title",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_page_url",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_timezone",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_user_agent",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_user_agent_data_brands",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "context_user_agent_data_mobile",
        "type": "BOOLEAN",
        "mode": "NULLABLE"
    },
    {
        "name": "context_user_agent_data_platform",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "event",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "event_text",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "id",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "loaded_at",
        "type": "TIMESTAMP",
        "mode": "NULLABLE"
    },
    {
        "name": "original_timestamp",
        "type": "TIMESTAMP",
        "mode": "NULLABLE"
    },
    {
        "name": "path",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "received_at",
        "type": "TIMESTAMP",
        "mode": "NULLABLE"
    },
    {
        "name": "sent_at",
        "type": "TIMESTAMP",
        "mode": "NULLABLE"
    },
    {
        "name": "timestamp",
        "type": "TIMESTAMP",
        "mode": "NULLABLE"
    },
    {
        "name": "user_id",
        "type": "STRING",
        "mode": "NULLABLE"
    },
    {
        "name": "uuid_ts",
        "type": "TIMESTAMP",
        "mode": "NULLABLE"
    },
    {
        "name": "viewport",
        "type": "STRING",
        "mode": "NULLABLE"
    }
]
EOF
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

  schema = <<EOF
[
  {
    "name": "anonymous_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_availability",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_cover",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_currency",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_object",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_visibility",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_ip",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_version",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_locale",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_object",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_position",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_type",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_referrer",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_title",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_timezone",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_brands",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_mobile",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_platform",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event_text",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "exit_path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "exit_viewport",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "loaded_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "original_timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "received_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "sent_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "time_spent",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "uuid_ts",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "viewport",
    "type": "STRING",
    "mode": "NULLABLE"
  }
]
EOF
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

  schema = <<EOF
[
  {
    "name": "anonymous_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_ip",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_version",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_locale",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_referrer",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_title",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_timezone",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_brands",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_mobile",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_platform",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event_text",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "loaded_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "original_timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "received_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "sent_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "uuid_ts",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "viewport",
    "type": "STRING",
    "mode": "NULLABLE"
  }
]
EOF
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

  schema = <<EOF
[
  {
    "name": "anonymous_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_ip",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_version",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_locale",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_referrer",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_title",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_timezone",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_brands",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_mobile",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_platform",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event_text",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "exit_path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "exit_viewport",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "loaded_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "original_timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "received_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "sent_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "time_spent",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "uuid_ts",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "viewport",
    "type": "STRING",
    "mode": "NULLABLE"
  }
]
EOF
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

  schema = <<EOF
[
  {
    "name": "anonymous_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_availability",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_currency",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_object",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_visibility",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_object",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_position",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_type",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_ip",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_version",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_locale",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_object",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_position",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_type",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_referrer",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_title",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_timezone",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_brands",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_mobile",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_platform",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "element",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event_text",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "loaded_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "original_timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "received_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "sent_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "uuid_ts",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "viewport",
    "type": "STRING",
    "mode": "NULLABLE"
  }
]
EOF
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

  schema = <<EOF
[
  {
    "name": "anonymous_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_availability",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_cover",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_currency",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_object",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_visibility",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_object",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_position",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_type",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_ip",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_version",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_locale",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_object",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_position",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_type",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_referrer",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_title",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_timezone",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_brands",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_mobile",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_platform",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event_text",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "loaded_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "original_timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "received_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "sent_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "uuid_ts",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "viewport",
    "type": "STRING",
    "mode": "NULLABLE"
  }
]
EOF
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

  schema = <<EOF
[
  {
    "name": "anonymous_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_availability",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_cover",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_currency",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_object",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_visibility",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_object",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_position",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_type",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_ip",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_version",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_locale",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_object",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_position",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_type",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_referrer",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_title",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_timezone",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_brands",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_mobile",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_platform",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event_text",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "exit_path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "exit_viewport",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "loaded_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "original_timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "received_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "sent_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "time_spent",
    "type": "FLOAT",
    "mode": "NULLABLE"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "uuid_ts",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "viewport",
    "type": "STRING",
    "mode": "NULLABLE"
  }
]
EOF
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

  schema = <<EOF
[
  {
    "name": "anonymous_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_ip",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_version",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_locale",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_referrer",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_title",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_timezone",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_brands",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_mobile",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_platform",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "email",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "loaded_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "original_timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "received_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "sent_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "uuid_ts",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  }
]
EOF
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

  schema = <<EOF
[
  {
    "name": "_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "anonymous_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_ip",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_version",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_locale",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_referrer",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_title",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_timezone",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_brands",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_mobile",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_platform",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "email",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event_text",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "full_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "loaded_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "original_timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "received_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "sent_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "uuid_ts",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "viewport",
    "type": "STRING",
    "mode": "NULLABLE"
  }
]
EOF
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

  schema = <<EOF
[
  {
    "name": "anonymous_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_availability",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_cover",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_currency",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_object",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_visibility",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_ip",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_version",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_locale",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_object",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_position",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_type",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_referrer",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_title",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_timezone",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_brands",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_mobile",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_platform",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event_text",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "loaded_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "original_timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "received_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "sent_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "uuid_ts",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "viewport",
    "type": "STRING",
    "mode": "NULLABLE"
  }
]
EOF
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

  schema = <<EOF
  [
    {
      "name": "anonymous_id",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_course_availability",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_course_cover",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_course_created_at",
      "type": "TIMESTAMP",
      "mode": "NULLABLE"
    },
    {
      "name": "context_course_currency",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_course_id",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_course_name",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_course_object",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_course_visibility",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_ip",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_library_name",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_library_version",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_locale",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_module_created_at",
      "type": "TIMESTAMP",
      "mode": "NULLABLE"
    },
    {
      "name": "context_module_id",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_module_name",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_module_object",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_module_position",
      "type": "INTEGER",
      "mode": "NULLABLE"
    },
    {
      "name": "context_module_type",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_page_path",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_page_referrer",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_page_title",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_page_url",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_timezone",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_user_agent",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_user_agent_data_brands",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "context_user_agent_data_mobile",
      "type": "BOOLEAN",
      "mode": "NULLABLE"
    },
    {
      "name": "context_user_agent_data_platform",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "event",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "event_text",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "exit_path",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "exit_viewport",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "id",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "loaded_at",
      "type": "TIMESTAMP",
      "mode": "NULLABLE"
    },
    {
      "name": "original_timestamp",
      "type": "TIMESTAMP",
      "mode": "NULLABLE"
    },
    {
      "name": "path",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "received_at",
      "type": "TIMESTAMP",
      "mode": "NULLABLE"
    },
    {
      "name": "sent_at",
      "type": "TIMESTAMP",
      "mode": "NULLABLE"
    },
    {
      "name": "time_spent",
      "type": "FLOAT",
      "mode": "NULLABLE"
    },
    {
      "name": "timestamp",
      "type": "TIMESTAMP",
      "mode": "NULLABLE"
    },
    {
      "name": "user_id",
      "type": "STRING",
      "mode": "NULLABLE"
    },
    {
      "name": "uuid_ts",
      "type": "TIMESTAMP",
      "mode": "NULLABLE"
    },
    {
      "name": "viewport",
      "type": "STRING",
      "mode": "NULLABLE"
    }
  ]
EOF
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

  schema = <<EOF
[
  {
    "name": "anonymous_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_ip",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_version",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_locale",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_referrer",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_title",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_timezone",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_brands",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_mobile",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_platform",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "loaded_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "original_timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "received_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "referrer",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "sent_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "title",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "uuid_ts",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  }
]
EOF
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

  schema = <<EOF
[
  {
    "name": "anonymous_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_availability",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_currency",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_object",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_course_visibility",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_object",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_position",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "context_element_type",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_ip",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_version",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_locale",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_created_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_object",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_position",
    "type": "INTEGER",
    "mode": "NULLABLE"
  },
  {
    "name": "context_module_type",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_referrer",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_title",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_timezone",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_brands",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_mobile",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_platform",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event_text",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "loaded_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "original_timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "received_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "sent_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "uuid_ts",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "viewport",
    "type": "STRING",
    "mode": "NULLABLE"
  }
]
EOF
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

  schema = <<EOF
[
  {
    "name": "anonymous_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_ip",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_version",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_locale",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_referrer",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_title",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_timezone",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_brands",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_mobile",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_platform",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "event_text",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "loaded_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "original_timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "received_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "sent_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "timestamp",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "user_id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "uuid_ts",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  }
]
EOF
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

  schema = <<EOF
[
  {
    "name": "context_ip",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_library_version",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_locale",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_path",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_referrer",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_title",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_page_url",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_timezone",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_brands",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_mobile",
    "type": "BOOLEAN",
    "mode": "NULLABLE"
  },
  {
    "name": "context_user_agent_data_platform",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "email",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "id",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "loaded_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "name",
    "type": "STRING",
    "mode": "NULLABLE"
  },
  {
    "name": "received_at",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  },
  {
    "name": "uuid_ts",
    "type": "TIMESTAMP",
    "mode": "NULLABLE"
  }
]
EOF
}