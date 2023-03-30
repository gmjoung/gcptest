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

  schema = <<EOF
[
  {
    "name": "name",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "name as string"
  },
  {
    "name": "age",
    "type": "INTEGER",
    "mode": "NULLABLE",
    "description": "age as an integer"
  },
  {
    "name": "gender",
    "type": "STRING",
    "mode": "NULLABLE",
    "description": "gender as string"
  }
]
EOF

}
