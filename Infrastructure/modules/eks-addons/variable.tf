variable "create" {
  description = "Controls if the EKS add-on should be created"
  type        = bool
  default     = true
}

variable "region" {
  description = "Region where this resource will be managed"
  type        = string
  default     = null
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "addon_name" {
  description = "Name of the EKS add-on"
  type        = string
}

variable "addon_version" {
  description = "Version of the EKS add-on"
  type        = string
  default     = null
}

variable "configuration_values" {
  description = "Custom configuration values for the add-on as a JSON string"
  type        = string
  default     = null
}

variable "service_account_role_arn" {
  description = "Existing IAM role ARN to bind to the add-on service account"
  type        = string
  default     = null
}

variable "preserve" {
  description = "Indicates if created resources should be preserved when deleting the add-on"
  type        = bool
  default     = true
}

variable "resolve_conflicts_on_create" {
  description = "How to resolve field value conflicts when creating the add-on"
  type        = string
  default     = "NONE"
}

variable "resolve_conflicts_on_update" {
  description = "How to resolve field value conflicts when updating the add-on"
  type        = string
  default     = "OVERWRITE"
}