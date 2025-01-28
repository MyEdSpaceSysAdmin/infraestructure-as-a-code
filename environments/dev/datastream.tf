data "google_secret_manager_secret_version" "bitrix_read_replica_password" {
  secret  = "bitrix-read-replica-password"
  project = var.project
}

resource "google_datastream_connection_profile" "bitrix_chat_mysql_connection" {
  display_name              = "bitrix-chat"
  connection_profile_id     = "bitrix-chat"
  location                  = var.region
  create_without_validation = false

  mysql_profile {
    hostname = "bitrix-read-replica.ctzlfpmjufbh.eu-west-2.rds.amazonaws.com"
    port     = 3306
    username = "admin"
    password = data.google_secret_manager_secret_version.bitrix_read_replica_password.secret_data
  }
}

# Imported from GCP sincere-hybrid-364510
resource "google_datastream_connection_profile" "bigquery_sink_connection" {
  display_name              = "bigquery-sink"
  connection_profile_id     = "bigquery-sink"
  location                  = var.region

  bigquery_profile {}
}

resource "google_datastream_stream" "bitrx_chat_mysql_to_bigquery" {
    display_name = "eu-west-2-mysql-bitrix-read-replica-sitemanager-db-to-bq"
    location     = var.region
    stream_id    = "eu-west-2-mysql-bitrix-read-replica-sitemanager-db-to-bq"

    source_config {
        source_connection_profile = google_datastream_connection_profile.bitrix_chat_mysql_connection.id
        mysql_source_config {
          include_objects {
            mysql_databases  {
              database = "sitemanager"
              mysql_tables {
                  table = "b_im_message"
              }
              mysql_tables {
                  table = "b_user"
              }
              mysql_tables {
                  table = "b_im_chat"
              }
                mysql_tables {
                  table = "b_imopenlines_session"
              }
            }
          }
          binary_log_position {}
        }
    }

    destination_config {
        destination_connection_profile = google_datastream_connection_profile.bigquery_sink_connection.id
        bigquery_destination_config {
            data_freshness = "900s"
            source_hierarchy_datasets {
                dataset_template {
                    location = var.region
                    dataset_id_prefix = "bitrix_chat_"
                }
            }
            merge {}
        }
    }

    backfill_all {}
    create_without_validation = false
    desired_state = "RUNNING"
}

data "google_secret_manager_secret_version" "filament_read_replica_password" {
  secret  = "filament-read-replica-password"
  project = var.project
}

# Can't import existing Connection profile to Terraform config without triggering to recreate it
# Just use this resource config when migrating to main projects
resource "google_datastream_connection_profile" "filament_mysql_connection" {
  display_name              = "${var.env}-filament-connection"
  connection_profile_id     = "${var.env}-filament-connection"
  location                  = var.region
  create_without_validation = false

  mysql_profile {
    hostname = "filament-read-replica.ctzlfpmjufbh.eu-west-2.rds.amazonaws.com"
    port     = 3306
    username = "data_team"
    password = data.google_secret_manager_secret_version.filament_read_replica_password.secret_data
  }
}

resource "google_datastream_stream" "filament_mysql_to_bigquery" {
    display_name = "${var.env}-eu-west2-mysql-filament-prod-db-to-bq"
    location     = var.region
    stream_id    = "${var.env}-eu-west2-mysql-filament-prod-db-to-bq"

    source_config {
        source_connection_profile = google_datastream_connection_profile.filament_mysql_connection.id
        mysql_source_config {
          include_objects {
            mysql_databases  {
              database = "filament_prod"
            }
            mysql_databases  {
              database = "filament_staging"
            }
            mysql_databases  {
              database = "filament_test"
            }
            mysql_databases  {
              database = "vapor"
            }
          }
          binary_log_position {}
        }
    }

    destination_config {
        destination_connection_profile = google_datastream_connection_profile.bigquery_sink_connection.id
        bigquery_destination_config {
            data_freshness = "900s"
            single_target_dataset {
              dataset_id = "${var.project}:filament"
            }
            merge {}
        }
    }

    backfill_all {}
    create_without_validation = false
    desired_state = "NOT_STARTED"
}
