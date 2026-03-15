output "arn" {
  description = "ARN of the EKS add-on"
  value       = try(aws_eks_addon.this[0].arn, null)
}

output "id" {
  description = "Cluster name and add-on name separated by a colon"
  value       = try(aws_eks_addon.this[0].id, null)
}
