resource "google_artifact_registry_repository" "teachfloor_fastapi_repository" {
  cleanup_policy_dry_run = true
  description            = null
  format                 = "DOCKER"
  kms_key_name           = null
  labels                 = {}
  location               = var.region
  mode                   = "STANDARD_REPOSITORY"
  project                = var.project
  repository_id          = "teachfloor-fastapi"
  docker_config {
    immutable_tags = false
  }
  vulnerability_scanning_config {
    enablement_config = "INHERITED"
  }
}
