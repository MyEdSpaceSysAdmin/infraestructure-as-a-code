resource "google_storage_bucket" "example_bucket" {
  name     = "${var.project}-example-bucket"
  location = var.default_region
  project  = var.project
  storage_class = "STANDARD"

  versioning {
    enabled = true
  } 
}
