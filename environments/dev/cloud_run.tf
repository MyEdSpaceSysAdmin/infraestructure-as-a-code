# Cloud Run service, and service accounts, and IAM roles for the Teachfloor Student Dashboard API
resource "google_service_account" "teachfloor_fastapi_service_account" {
  account_id   = "teachfloor-fastapi"
  display_name = "teachfloor-fastapi"
}

resource "google_project_iam_member" "teachfloor_fastapi_service_account" {
  for_each = toset([
    "roles/bigquery.dataViewer",
    "roles/bigquery.jobUser"
  ])

  project = var.project
  role    = each.value
  member  = "serviceAccount:${google_service_account.teachfloor_fastapi_service_account.email}"
}

# Allows clients to invoke endpoints from the Cloud Run service
resource "google_service_account" "teachfloor_fastapi_user_service_account" {
  account_id   = "teachfloor-fastapi-user"
  display_name = "teachfloor_fastapi_user"
  description  = "Service account for accessing the Teachfloor Student Dashboard endpoints from deployed Cloud Run service teachfloor_fastapi"
}

resource "google_project_iam_member" "teachfloor_fastapi_user_service_account" {
  for_each = toset([
    "roles/run.invoker",
    "roles/iam.serviceAccountTokenCreator"
  ])

  project = var.project
  role    = each.value
  member  = "serviceAccount:${google_service_account.teachfloor_fastapi_user_service_account.email}"
}

resource "google_cloud_run_v2_service" "teachfloor_fastapi" {
  annotations          = {}
  client               = "gcloud"
  client_version       = "510.0.0"
  custom_audiences     = []
  deletion_protection  = true
  description          = null
  ingress              = "INGRESS_TRAFFIC_ALL"
  invoker_iam_disabled = false
  labels               = {}
  launch_stage         = "GA"
  location             = var.region
  name                 = "teachfloor-fastapi"
  project              = var.project

  lifecycle {
      ignore_changes = [
        annotations,
        client,
        client_version,
        custom_audiences,
        deletion_protection,
        description,
        ingress,
        invoker_iam_disabled,
        labels,
        launch_stage,
        location,
        name,
        project,
        scaling,
        template,
        traffic
      ]
    }


  scaling {
    min_instance_count = 1
  }
  template {
    annotations                      = {}
    encryption_key                   = null
    execution_environment            = null
    labels                           = {}
    max_instance_request_concurrency = 80
    revision                         = null
    service_account                  = google_service_account.teachfloor_fastapi_service_account.email
    session_affinity                 = false
    timeout                          = "300s"
    containers {
      args        = []
      command     = []
      depends_on  = []
      image       = "europe-west2-docker.pkg.dev/sincere-hybrid-364510/teachfloor-fastapi/teachfloor-fastapi:latest"
      name        = "teachfloor-fastapi-1"
      working_dir = null
      env {
        name  = "API_URL"
        value = "https://teachfloor-fastapi-986227589812.europe-west2.run.app"
      }
      env {
        name  = "ENV"
        value = "dev"
      }
      ports {
        container_port = 8080
        name           = "http1"
      }
      resources {
        cpu_idle = true
        limits = {
          cpu    = "1000m"
          memory = "512Mi"
        }
        startup_cpu_boost = true
      }
      startup_probe {
        failure_threshold     = 1
        initial_delay_seconds = 0
        period_seconds        = 240
        timeout_seconds       = 240
        tcp_socket {
          port = 8080
        }
      }
    }
    scaling {
      max_instance_count = 100
      min_instance_count = 0
    }
  }
  traffic {
    percent  = 100
    revision = null
    tag      = null
    type     = "TRAFFIC_TARGET_ALLOCATION_TYPE_LATEST"
  }
}
