locals {
  members_schema = [
    { name = "id", type = "STRING", mode = "NULLABLE"}, 
    { name = "object", type = "STRING", mode = "NULLABLE"}, 
    { name = "first_name", type = "STRING", mode = "NULLABLE"}, 
    { name = "last_name", type = "STRING", mode = "NULLABLE"}, 
    { name = "full_name", type = "STRING", mode = "NULLABLE"}, 
    { name = "avatar", type = "STRING", mode = "NULLABLE"}, 
    { name = "email", type = "STRING", mode = "NULLABLE"}, 
    { name = "is_email_verified", type = "STRING", mode = "NULLABLE"}, 
    { name = "last_seen", type = "STRING", mode = "NULLABLE"}
  ]
}

variable "tables" {
  default = [
    {
      table_name = "members"
      schema     = local.members_schema
    }
  ]
}
