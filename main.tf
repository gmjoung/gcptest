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

# Enabling Cloud Resource Manager
resource "google_project_service" "cloud_resource_manager" {
  service = "cloudresourcemanager.googleapis.com"
}

# Enabling required APIs for Vertex AI Workbench usage
resource "google_project_service" "vertex_ai" {
  service = "aiplatform.googleapis.com"
  depends_on = [google_project_service.cloud_resource_manager]
}
resource "google_project_service" "notebooks" {
  service = "notebooks.googleapis.com"
  depends_on = [google_project_service.cloud_resource_manager]
}

# Vertex AI instance
resource "google_workflows_region_instance" "my_instance" {
  name     = "my-workbench-instance"
  region   = "europe-west11"
  location = "europe-west1"


  # Define the notebook configuration
  notebook_config {
    container_image_uri = "gcr.io/deeplearning-platform-release/tf2-cpu.2-1"
    port = 8080
  }
}

# Create a firewall rule to allow access to the notebook
resource "google_compute_firewall" "notebook_firewall" {
  name    = "notebook-firewall"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["8080"]
  }

  source_ranges = ["0.0.0.0/0"]
}
