variable "project" {}

variable "env" {
  description = "The differentiator of the resource environment (e.g. dev, uat, prod)"
  type = string
  default = "dev"
}

variable "default_region" {
  description = "The region in which to create the BigQuery dataset."
  type        = string
  default     = "europe-west1"
}

variable "dataset_name" {
  description = "The name of the dataset you want to instantiate"
  type = string
  default = ""
}