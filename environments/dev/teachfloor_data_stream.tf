resource "google_pubsub_topic" "teachfloor_events_topic" {
  kms_key_name               = null
  labels                     = {}
  message_retention_duration = null
  name                       = "teachfloor-events"
  project                    = var.project
}   

resource "google_pubsub_subscription" "teachfloor_events_sub" {
  ack_deadline_seconds         = 10
  enable_exactly_once_delivery = false
  enable_message_ordering      = false
  filter                       = null
  labels                       = {}
  message_retention_duration   = "604800s"
  name                         = "teachfloor-events-sub"
  project                      = var.project
  retain_acked_messages        = false
  topic                        = google_pubsub_topic.teachfloor_events_topic.id
  expiration_policy {
    ttl = "2678400s"
  }
}

resource "google_storage_bucket" "teachfloor_dataflow_ingestion_bucket" {
  default_event_based_hold    = false
  enable_object_retention     = false
  force_destroy               = false
  labels                      = {}
  location                    = var.region
  name                        = "teachfloor-to-bq-dataflow-ingestion-bucket"
  project                     = var.project
  public_access_prevention    = "enforced"
  requester_pays              = false
  rpo                         = null
  storage_class               = "STANDARD"
  uniform_bucket_level_access = true
  hierarchical_namespace {
    enabled = false
  }
  soft_delete_policy {
    retention_duration_seconds = 604800
  }
}
