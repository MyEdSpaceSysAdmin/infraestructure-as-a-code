
module "data_lake_bucket" {
  source      = "../../modules/storage"
  project     = var.project
  env         = local.env
  bucket_name = "data-lake-bucket"
}

resource "google_storage_bucket_object" "data_lake_data_source_folders" {
  for_each = toset([
    "stripe/",
    "teachfloor/",
    "sales_google_sheets/"
  ])

  name    = each.key
  bucket  = module.data_lake_bucket.bucket_name
  content = ""
}