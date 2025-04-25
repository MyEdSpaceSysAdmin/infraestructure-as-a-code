resource "google_compute_instance" "airbyte-dbt-sandbox" {
  boot_disk {
    auto_delete = true
    device_name = "airbyte-dbt-sandbox"

    initialize_params {
      image = "projects/ubuntu-os-cloud/global/images/ubuntu-minimal-2504-plucky-amd64-v20250415"
      size  = 250
      type  = "pd-balanced"
    }

    mode = "READ_WRITE"
  }

  can_ip_forward      = false
  deletion_protection = false
  enable_display      = false

  labels = {
    goog-ec-src = "vm_add-tf"
  }

  machine_type = "n2-highcpu-64"
  name         = "airbyte-dbt-sandbox"

  network_interface {
    access_config {}
    subnetwork  = "projects/sincere-hybrid-364510/regions/europe-west2/subnetworks/default"
    stack_type  = "IPV4_ONLY"
    queue_count = 0
  }

  metadata = {
    enable-oslogin = "FALSE"
  }

  scheduling {
    automatic_restart   = true
    on_host_maintenance = "MIGRATE"
    preemptible         = false
    provisioning_model  = "STANDARD"
  }

  service_account {
    email  = "dbt-user@sincere-hybrid-364510.iam.gserviceaccount.com"
    scopes = ["https://www.googleapis.com/auth/devstorage.read_only", "https://www.googleapis.com/auth/logging.write", "https://www.googleapis.com/auth/monitoring.write", "https://www.googleapis.com/auth/service.management.readonly", "https://www.googleapis.com/auth/servicecontrol", "https://www.googleapis.com/auth/trace.append"]
  }

  shielded_instance_config {
    enable_integrity_monitoring = true
    enable_secure_boot          = false
    enable_vtpm                 = true
  }

  tags = ["http-server", "https-server", "web-access"]
  zone = "europe-west2-a"
}

locals {
  airbyte_roles = [
    "roles/bigquery.dataEditor", 
    "roles/bigquery.jobUser"
  ]
}

resource "google_service_account" "airbyte_service_account" {
  account_id   = "airbyte-user"
  display_name = "Airbyte service account for DEV"
}

resource "google_project_iam_member" "airbyte_service_account_roles" {
  for_each = toset(local.airbyte_roles)
  project  = var.project
  member   = "serviceAccount:${google_service_account.airbyte_service_account.email}"
  role     = each.key
}
