variable "project" {}
variable "env" {}

variable "default_region" {
  description = "The region in which to create the google cloud storage bucket."
  type        = string
  default     = "europe-west1"
}
