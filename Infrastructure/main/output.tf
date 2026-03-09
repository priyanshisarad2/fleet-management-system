output "eks_oidc_provider_arn" {
  description = "OIDC provider ARN used for IRSA (null if EKS not created or IRSA disabled)"
  value       = try(module.eks.oidc_provider_arn, null)
}

output "eks_cluster_oidc_issuer_url" {
  description = "OIDC issuer URL used for IRSA (null if EKS not created)"
  value       = try(module.eks.cluster_oidc_issuer_url, null)
}


# # Output the private key for the k8s nodes (shared key across all on-prem k8s nodes)
# output "k8s_nodes_private_key" {
#   value     = module.k8s-nodes-key-pair.private_key_pem
#   sensitive = true
# }