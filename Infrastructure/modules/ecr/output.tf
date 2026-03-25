output "ecr_repository_url" {
  description = "The URL of the repository"
  value       = try(module.ecr.repository_url, null)
}
output "ecr_login_endpoint" {
  description = "The ECR login endpoint (registry URI without repo name)"
  value       = try(split("/", module.ecr.repository_url)[0], null)
}