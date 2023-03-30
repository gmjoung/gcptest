# Connecting to Project
provider "google" {
  project = "inbound-decker-382207" #test project ID from GCP
  region  = "europe-west1"
}

# Creating BQ Dataset
resource "google_bigquery_dataset" "my_dataset" {
  dataset_id                  = "dataset1"
  friendly_name               = "Gumin Dataset"
  description                 = "test dataset to see if it can be integrated into Vertex AI"
  location                    = "EU"
  default_table_expiration_ms = "3600000" #100 hours expiration time
}

# Setting up table in BQ dataset
resource "google_bigquery_table" "my_table" {
  dataset_id = google_bigquery_dataset.my_dataset.dataset_id
  table_id   = "table1"

  schema {
    fields {
      name = "name"
      type = "STRING"
    }
    fields {
      name = "age"
      type = "INTEGER"
    }
  }
}

# Adding basic data to created table in BQ dataset !removed for now
#resource "google_bigquery_table_data" "my_table_data" {
#   dataset_id = google_bigquery_dataset.my_dataset.dataset_id
#   table_id   = google_bigquery_table.my_table.table_id

#   source_format = "NEWLINE_DELIMITED_JSON"

#   json = <<JSON
#   { "name": "Gumin", "age": 27 }
#   { "name": "Arpan2", "age": 26 }
#   JSON
# }
