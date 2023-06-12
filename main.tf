
provider "google" {
  project     = var.project_id
  region      = var.region
  zone        = var.zone
  credentials = file("./keys/maia-issue-tracker-dev-ede530afcdfb.json")
}

terraform {
  backend "gcs" {
    bucket  	= "maia-issue-tracker-dev-tf-state"
    prefix  	= "terraform/state"
    credentials = "./keys/maia-issue-tracker-dev-ede530afcdfb.json"
  }
}

resource "google_service_account" "github-wif-sa" {
  account_id   = "github-wif-sa"
  display_name = "Github WIF Service Account"
}

resource "google_project_iam_member" "artifact_registry_binding" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github-wif-sa.email}"
}

resource "google_artifact_registry_repository" "build-repo" {
  location      = var.region
  repository_id = "build"
  description   = "Images built from Github Actions"
  format        = "DOCKER"
}

module "github_oidc" {
  source  = "terraform-google-modules/github-actions-runners/google//modules/gh-oidc"
  version = "3.1.1"
  project_id  = var.project_id
  pool_id     = "github-pool"
  provider_id = "github-provider"
  attribute_mapping = {
    "google.subject"             = "assertion.sub"
    "attribute.actor"            = "assertion.actor"
    "attribute.repository"       = "assertion.repository"
    "attribute.repository_owner" = "assertion.repository_owner"
  }
  sa_mapping = {
    "github-sa" = {
      sa_name   = "projects/${var.project_id}/serviceAccounts/${google_service_account.github-wif-sa.email}"
      attribute = "attribute.repository/${var.github_repo}"
    }
  }
}