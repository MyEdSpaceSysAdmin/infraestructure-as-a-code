resource "google_service_account" "cloud_composer_environment_service_account" {
  account_id   = "${var.env}-cloud-composer-env-sa"
  display_name = "Cloud Composer environment service account for DEV"
}

resource "google_project_iam_member" "cloud_composer_environment_service_account" {
  project = var.project
  member  = "serviceAccount:${google_service_account.cloud_composer_environment_service_account.email}"
  role    = "roles/composer.worker"
}

resource "google_project_iam_member" "cloud_composer_service_agent_service_account" {
  project = var.project
  member  = "serviceAccount:service-${var.project_number}@cloudcomposer-accounts.iam.gserviceaccount.com"
  role    = "roles/composer.ServiceAgentV2Ext"
}

# TODO: Manage via Terraform Composer when Composer 3 images are supported 
# Current keep getting this error message:
# Error: "config.0.software_config.0.image_version" ("composer-3-airflow-2.10.2") doesn't match regexp "composer-([0-9]+\\.[0-9]+\\.[0-9]+(-preview\\.[0-9]+)?|latest)-airflow-([0-9]+\\.[0-9]+(\\.[0-9]+.*)?)"
# The naming convention of composer 3 images appear to not be supported yet by the image_version parameter which is stupid. Using composer-3.0.0-airflow-2.10.2 also does not work because such image_version does not exist.

# resource "google_composer_environment" "cloud_composer_environment" {
#   name   = "${var.env}-${var.project}-cloud-composer-3-environment"
#   region = var.region

#   config {
#     software_config {
#       image_version = "composer-3-airflow-2.10.2"
#     }

#     node_config {
#       service_account = google_service_account.cloud_composer_environment_service_account.email
#     }
#   }

#   depends_on = [ google_project_iam_member.cloud_composer_environment_service_account, google_project_iam_member.cloud_composer_service_agent_service_account ]
# }