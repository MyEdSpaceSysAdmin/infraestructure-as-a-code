resource "google_storage_bucket" "standard_bucket" {
  name     = "${var.env}-${var.bucket_name}"
  location = var.default_region
  project  = var.project
  storage_class = "STANDARD"

  versioning {
    enabled = true
  }
  lifecycle {
    prevent_destroy = true
  }
}
