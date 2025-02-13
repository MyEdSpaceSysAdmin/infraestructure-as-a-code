# Cloud Build trigger and trigger service account for automating the deployment of the Teachfloor Student Dashboard API service to Cloud Run
resource "google_service_account" "teachfloor_fastapi_cloud_build_service_account" {
  account_id   = "teachfloor-fastapi-cloud-build"
  display_name = "teachfloor-fastapi-cloud-build"
  description  = "Service account for the Cloud Build trigger that deploys to the Cloud Run teachfloor-fastapi service"
}

resource "google_project_iam_member" "teachfloor_fastapi_cloud_build_service_account" {
  for_each = toset([
    "roles/artifactregistry.writer",
    "roles/run.developer",
    "roles/logging.logWriter",
    "roles/iam.serviceAccountUser",
    "roles/storage.admin"
  ])

  project = "sincere-hybrid-364510"
  role    = each.value
  member  = "serviceAccount:${google_service_account.teachfloor_fastapi_cloud_build_service_account.email}"
}

resource "google_cloudbuild_trigger" "teachfloor_fastapi_cloud_build_trigger" {
  description        = "Cloud Build trigger for deploying to the Cloud Run service 'teachfloor-fastapi'"
  disabled           = false
  filename           = "cloudbuild.yaml"
  filter             = null
  ignored_files      = []
  include_build_logs = null
  included_files     = []
  location           = var.region
  name               = "teachfloor-fastapi-cloud-build-trigger"
  project            = var.project
  service_account    = "projects/${var.project}/serviceAccounts/${google_service_account.teachfloor_fastapi_cloud_build_service_account.email}"
  substitutions      = {}
  tags               = []
  approval_config {
    approval_required = false
  }
  github {
    enterprise_config_resource_name = null
    name                            = "teachfloor-student-dashboard-api"
    owner                           = "MyEdSpaceSysAdmin"
    push {
      branch       = "^main$"
      invert_regex = false
      tag          = null
    }
  }
}
