resource "google_apikeys_key" "teachfloor_student_dashboard_api_key" {
  display_name = "Student Dashboard API key"
  name         = "298c095b-93c8-4b85-b42a-1b6c28d3a8c5"
  project      = var.project
}
