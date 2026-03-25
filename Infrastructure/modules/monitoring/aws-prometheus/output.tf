output "workspace_arn" {
  description = "ARN of the AMP workspace"
  value       = module.managed-service-prometheus.workspace_arn
}

output "workspace_id" {
  description = "ID of the AMP workspace"
  value       = module.managed-service-prometheus.workspace_id
}

output "workspace_prometheus_endpoint" {
  description = "Remote write/query endpoint for the AMP workspace"
  value       = module.managed-service-prometheus.workspace_prometheus_endpoint
}
