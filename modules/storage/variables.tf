variable "project" {}
variable "env" {
  description = "The differentiator of the resource environment (e.g. dev, uat, prod)"
  type = string
  default = "dev"
}

variable "default_region" {
  description = "The region in which to create the google cloud storage bucket."
  type        = string
  default     = "europe-west2"
}

variable "bucket_name" {
  description = "The name of the bucket you want to instantiate"
  type = string
  default = "data-lake-bucket"
}