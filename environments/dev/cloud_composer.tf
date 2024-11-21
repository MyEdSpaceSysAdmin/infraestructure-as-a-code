resource "google_project_service" "cloud_composer_api" {
  project = var.project
  service = "composer.googleapis.com"

  disable_on_destroy         = false
  disable_dependent_services = false
}

resource "google_service_account" "cloud_composer_environment_service_account" {
  account_id   = "${var.env}-cloud-composer-environment-service-account"
  display_name = "Cloud Composer environment service account for DEV"
}

resource "google_project_iam_member" "cloud_composer_environment_service_account" {
  project = var.project
  member  = format("serviceAccount:%s", google_service_account.cloud_composer_environment_service_account.email)
  role    = "roles/composer.worker"
}

resource "google_service_account_iam_member" "custom_service_account" {
  service_account_id = google_service_account.cloud_composer_environment_service_account.name
  role               = "roles/composer.ServiceAgentV2Ext"
  member             = "serviceAccount:service-${var.project_number}@cloudcomposer-accounts.iam.gserviceaccount.com"
}

resource "google_composer_environment" "cloud_composer_environment" {
  name   = "${var.env}-${var.project}-cloud-composer-environment"
  region = var.region

  config {
    software_config {
      image_version = "composer-2.9.11-airflow-2.9.3"
    }

    node_config {
      service_account = google_service_account.cloud_composer_environment_service_account.email
    }

    database_config {
      zone = var.zone
    }
  }
}