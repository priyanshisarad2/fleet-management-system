variable "create_grafana" {
  description = "Controls whether the Amazon Managed Grafana resources should be created"
  type        = bool
  default     = false
}

variable "create_workspace" {
  description = "Controls whether the Amazon Managed Grafana workspace should be created"
  type        = bool
  default     = false
}

variable "grafana_version" {
  description = "Grafana version to use for the managed workspace. If null, the provider default is used."
  type        = string
  default     = null
}

variable "workspace_name" {
  description = "Name of the Amazon Managed Grafana workspace"
  type        = string
  default     = null
}

variable "workspace_description" {
  description = "Description of the Amazon Managed Grafana workspace"
  type        = string
  default     = null
}

variable "account_access_type" {
  description = "The type of account access for the workspace. Valid values are CURRENT_ACCOUNT and ORGANIZATION"
  type        = string
  default     = "CURRENT_ACCOUNT"
}

variable "permission_type" {
  description = "Whether Grafana workspace permissions are service-managed or customer-managed"
  type        = string
  default     = "SERVICE_MANAGED"
}

variable "authentication_providers" {
  description = "Authentication providers for the workspace. Valid values are AWS_SSO, SAML, or both"
  type        = list(string)
  default     = ["AWS_SSO"]
}

variable "data_sources" {
  description = "AWS data sources to enable in the Grafana workspace"
  type        = list(string)
  default     = ["PROMETHEUS"]
}

variable "network_access_control" {
  description = "Configuration for network access to the Grafana workspace"
  type        = any
  default     = {}
}

variable "associate_license" {
  description = "Whether to associate a Grafana Enterprise license with the workspace"
  type        = bool
  default     = false
}

variable "role_associations" {
  description = "Map of Grafana workspace roles to IAM Identity Center user/group IDs"
  type        = any
  default     = {}
}

variable "tags" {
  description = "Tags to apply to the Grafana workspace resources"
  type        = map(string)
  default     = {}
}
