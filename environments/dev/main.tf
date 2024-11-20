# Copyright 2019 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


locals {
  env = "dev"
}

provider "google" {
  impersonate_service_account = "terraform-user@${var.project}.iam.gserviceaccount.com"
  project                     = var.project
  region                      = var.region
  zone                        = var.zone
}

# module "vpc" {
#   source  = "../../modules/vpc"
#   project = var.project
#   env     = local.env
# }

# module "firewall" {
#   source  = "../../modules/firewall"
#   project = var.project
#   subnet  = module.vpc.subnet
# }

module "dataset" {
  source  = "../../modules/dataset"
  project = var.project
  env     = local.env
}

module "data_lake_bucket" {
  source      = "../../modules/storage"
  project     = var.project
  env         = local.env
  bucket_name = "data_lake_bucket"
}

resource "google_storage_bucket_object" "folders" {
  for_each = toset([
    "stripe/",
    "teachfloor/",
    "sales_google_sheets/"
  ])

  name    = each.key
  bucket  = module.data_lake_bucket.bucket_name
  content = ""
}
