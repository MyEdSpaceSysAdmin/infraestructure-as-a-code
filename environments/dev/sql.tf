# Imported from GCP sincere-hybrid-364510
resource "google_sql_database_instance" "bitrix_get_data_mysql_instance" {
  database_version     = "MYSQL_8_0_31"
  deletion_protection  = true
  encryption_key_name  = null
  instance_type        = "CLOUD_SQL_INSTANCE"
  maintenance_version  = "MYSQL_8_0_31.R20241208.01_00"
  master_instance_name = null
  name                 = "bitrix-get-data"
  project              = "sincere-hybrid-364510"
  region               = "europe-west1" # TODO: Update to europe-west2 when migrating to UAT and PROD
  replica_names        = []
  lifecycle {
    # [GAB] Currently these values are set to 0 and 0 respectively
    # however, Terraform does not allow these 0 values in the config
    # and will force maintainers to update the values to appropriate ones
    # (e.g. 7, and 1024 respectively) which will cause to update the 
    # SQL instance
    ignore_changes = [
      settings[0].maintenance_window[0].day,
      settings[0].insights_config[0].query_string_length,
    ]
  }
  
  settings {
    activation_policy            = "ALWAYS"
    availability_type            = "ZONAL"
    collation                    = null
    connector_enforcement        = "NOT_REQUIRED"
    deletion_protection_enabled  = true
    disk_autoresize              = true
    disk_autoresize_limit        = 0
    disk_size                    = 100
    disk_type                    = "PD_SSD"
    edition                      = "ENTERPRISE"
    enable_dataplex_integration  = false
    enable_google_ml_integration = false
    pricing_plan                 = "PER_USE"
    tier                         = "db-custom-1-3840"
    time_zone                    = null
    user_labels                  = {}
    backup_configuration {
      binary_log_enabled             = true
      enabled                        = true
      location                       = "eu"
      point_in_time_recovery_enabled = false
      start_time                     = "03:00"
      transaction_log_retention_days = 7
      backup_retention_settings {
        retained_backups = 7
        retention_unit   = "COUNT"
      }
    }
    data_cache_config {
      data_cache_enabled = false
    }
    insights_config {
      query_insights_enabled  = false
      query_plans_per_minute  = 0
      query_string_length     = 1024
      record_application_tags = false
      record_client_address   = false
    }
    ip_configuration {
      allocated_ip_range                            = null
      enable_private_path_for_google_cloud_services = false
      ipv4_enabled                                  = true
      private_network                               = null
      server_ca_mode                                = "GOOGLE_MANAGED_INTERNAL_CA"
      server_ca_pool                                = null
      ssl_mode                                      = "ALLOW_UNENCRYPTED_AND_ENCRYPTED"

      # Might have to update this when we migrate projects
      authorized_networks {
        expiration_time = null
        name            = "bitrix-ip"
        value           = "78.40.216.83"
      }
      authorized_networks {
        expiration_time = null
        name            = "datastream-eu-1"
        value           = "35.189.120.213"
      }
      authorized_networks {
        expiration_time = null
        name            = "datastream-eu-2"
        value           = "34.89.121.226"
      }
      authorized_networks {
        expiration_time = null
        name            = "datastream-eu-3"
        value           = "34.105.244.177"
      }
      authorized_networks {
        expiration_time = null
        name            = "datastream-eu-4"
        value           = "35.197.249.117"
      }
      authorized_networks {
        expiration_time = null
        name            = "datastream-eu-5"
        value           = "35.242.151.51"
      }
      authorized_networks {
        expiration_time = null
        name            = "datastream1"
        value           = "35.187.27.174"
      }
      authorized_networks {
        expiration_time = null
        name            = "datastream2"
        value           = "104.199.6.64"
      }
      authorized_networks {
        expiration_time = null
        name            = "datastream3"
        value           = "35.205.33.30"
      }
      authorized_networks {
        expiration_time = null
        name            = "datastream4"
        value           = "34.78.213.130"
      }
      authorized_networks {
        expiration_time = null
        name            = "datastrean5"
        value           = "35.205.125.111"
      }
    }
    location_preference {
      follow_gae_application = null
      secondary_zone         = null
      zone                   = "europe-west1-d"
    }
    maintenance_window {
      day          = 7
      hour         = 0
      update_track = "canary"
    }
  }
}

# Imported from GCP sincere-hybrid-364510
# TODO: Figure out password or just create a new one and store to Secret Manager
resource "google_sql_user" "bitrix_read_user" {
  deletion_policy = null
  host            = "%"
  instance        = "bitrix-get-data"
  name            = "bitrix-read-user"
  project         = var.project
  type            = null
}
