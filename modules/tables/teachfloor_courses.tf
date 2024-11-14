locals {
  courses_schema = [
    { name = "id", type = "STRING", mode = "NULLABLE"}, 
    { name = "object", type = "STRING", mode = "NULLABLE"}, 
    { name = "name", type = "STRING", mode = "NULLABLE"}, 
    { name = "created_at", type = "STRING", mode = "NULLABLE"}, 
    { name = "cover", type = "STRING", mode = "NULLABLE"}, 
    { name = "availability", type = "STRING", mode = "NULLABLE"}, 
    { name = "visibility", type = "STRING", mode = "NULLABLE"}, 
    { name = "start_date", type = "STRING", mode = "NULLABLE"}, 
    { name = "end_date", type = "STRING", mode = "NULLABLE"}, 
    { name = "currency", type = "STRING", mode = "NULLABLE"}, 
    { name = "price", type = "INTEGER", mode = "NULLABLE"}, 
    { name = "free_label", type = "STRING", mode = "NULLABLE"}, 
    { name = "url", type = "STRING", mode = "NULLABLE"}, 
    { name = "public_url", type = "STRING", mode = "NULLABLE"}, 
    { name = "join_url", type = "STRING", mode = "NULLABLE"}, 
    { name = "metadata.testmd1", type = "STRING", mode = "NULLABLE"}, 
    { name = "metadata.testmd2", type = "STRING", mode = "NULLABLE"}, 
    { name = "metadata.product_id", type = "STRING", mode = "NULLABLE"}, 
    { name = "metadata.teacher_id", type = "STRING", mode = "NULLABLE"}, 
    { name = "metadata.key1", type = "STRING", mode = "NULLABLE"},
  ]
}

variable "tables" {
  default = [
    {
      table_name = "courses"
      schema     = local.courses_schema
    }
  ]
}
