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

terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "6.16.0"
    }
  }
}

provider "google" {
  impersonate_service_account = "terraform-user@${var.project}.iam.gserviceaccount.com"
  project                     = var.project
  region                      = var.region
  zone                        = var.zone
}

resource "google_project_service" "cloud_composer_api" {
  project = var.project
  service = "composer.googleapis.com"

  disable_on_destroy         = false
  disable_dependent_services = false
}

