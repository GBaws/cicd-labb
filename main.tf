terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 7.0"
    }
  }
}

provider "google" {
  project = "gcp-bootcamp-labs"
  region  = "us-central1"
  zone    = "us-central1-a"
}

# Enable APIs
resource "google_project_service" "services" {
  for_each = toset([
    "artifactregistry.googleapis.com",
    "container.googleapis.com",
    "cloudbuild.googleapis.com"
  ])

  service = each.value
  disable_on_destroy = false
}

# Artifact Registry
resource "google_artifact_registry_repository" "repo" {
  location      = "us-central1"
  repository_id = "payments-repo"
  format        = "DOCKER"

  depends_on = [google_project_service.services]
}

# GKE Cluster
resource "google_container_cluster" "cluster" {
  name     = "payments-cluster"
  location = "us-central1-a"

  remove_default_node_pool = true
  initial_node_count       = 1

  deletion_protection = false

  depends_on = [google_project_service.services]
}

# Node Pool
resource "google_container_node_pool" "nodes" {
  name       = "primary-node-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.cluster.name
  node_count = 2

  node_config {
    machine_type = "e2-medium"
  }
}