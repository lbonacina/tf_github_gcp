output "github_wif_sa_name" {
  description = "Pool name"
  value       = "${google_service_account.github-wif-sa.email}"
}

output "provider_name" {
  description = "Provider name"
  value       = module.github_oidc.provider_name
}