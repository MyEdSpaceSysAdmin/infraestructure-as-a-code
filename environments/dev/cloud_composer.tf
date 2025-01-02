locals {
  cloud_composer_roles = [
    "roles/composer.worker",
    "roles/bigquery.admin",
    "roles/secretmanager.secretAccessor",
    "roles/storage.admin"
  ]
}

resource "google_service_account" "cloud_composer_environment_service_account" {
  account_id   = "${var.env}-cloud-composer-env-sa"
  display_name = "Cloud Composer environment service account for DEV"
}

resource "google_project_iam_member" "cloud_composer_environment_service_account" {
  for_each = toset(local.cloud_composer_roles)
  project  = var.project
  member   = "serviceAccount:${google_service_account.cloud_composer_environment_service_account.email}"
  role     = each.key
}

resource "google_project_iam_member" "cloud_composer_service_agent_service_account" {
  project = var.project
  member  = "serviceAccount:service-${var.project_number}@cloudcomposer-accounts.iam.gserviceaccount.com"
  role    = "roles/composer.ServiceAgentV2Ext"
}

resource "google_composer_environment" "cloud_composer_environment" {
  name   = "${var.env}-${var.project}-cloud-composer-2-environment"
  region = var.region

  config {

    software_config {
      image_version = "composer-2.10.1-airflow-2.10.2"

      pypi_packages = {
        google-api-python-client    = "==2.135.0"
        google-cloud-storage        = "==2.18.2"
        stripe                      = "==9.9.0"
        google-cloud-bigquery       = "==3.27.0"
        google-cloud-secret-manager = "==2.21.1"
        pandas                      = "==2.2.3"
      }
    }

    node_config {
      service_account = google_service_account.cloud_composer_environment_service_account.email
    }

    workloads_config {
      scheduler {
        cpu        = 1
        memory_gb  = 2
        storage_gb = 5
        count      = 1
      }

      triggerer {
        count     = 1
        cpu       = 0.5
        memory_gb = 1
      }

      web_server {
        cpu        = 1
        memory_gb  = 2
        storage_gb = 5
      }

      worker {
        cpu        = 1.5
        memory_gb  = 4
        storage_gb = 10
        min_count  = 2
        max_count  = 6
      }
    }
  }

  depends_on = [google_project_iam_member.cloud_composer_environment_service_account, google_project_iam_member.cloud_composer_service_agent_service_account]
}