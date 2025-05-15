locals {
  impersonation_members = [
    "user:gabriel.gonzales@myedspace.co.uk",
    "user:mikhail.karanik@myedspace.co.uk",
    "serviceAccount:dev-cloud-composer-dbt-env-sa@sincere-hybrid-364510.iam.gserviceaccount.com",
  ]
}

resource "google_service_account_iam_member" "allow_dbt_service_account_impersonators" {
  for_each = toset(local.impersonation_members)

  service_account_id = "projects/${var.project}/serviceAccounts/dbt-user@sincere-hybrid-364510.iam.gserviceaccount.com"
  role               = "roles/iam.serviceAccountTokenCreator"
  member             = each.value
}
