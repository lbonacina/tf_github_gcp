variable "project_id" {
  description = "The Project ID"
  type        = string
}

variable "region" {
  description = "The Project Region"
  type        = string
  default     = "europe-west8"
}

variable "zone" {
  description = "The Project Zone"
  type        = string
  default     = "europe-west8-a"
}

variable "github_repo" {
  description = "The Github Repo URL, in the format <user>/<repo>"
  type        = string
}
