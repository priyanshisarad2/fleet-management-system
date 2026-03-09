######## Global ########

variable "region" {
  type    = string
  default = "us-east-1"
}

variable "env" {
  type    = string
  default = "dev"
}

variable "project_name" {
  type    = string
  default = "project"
}

######## VPC ########

variable "create_vpc" {
  description = "Controls if VPC should be created"
  type        = bool
  default     = false
}

variable "cidr" {
  description = "The IPv4 CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "public_subnet_names" {
  description = "Explicit values to use in the Name tag on public subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "private_subnet_names" {
  description = "Explicit values to use in the Name tag on private subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "database_subnets" {
  description = "A list of database subnets inside the VPC"
  type        = list(string)
  default     = []
}

variable "database_subnet_names" {
  description = "Explicit values to use in the Name tag on database subnets. If empty, Name tags are generated"
  type        = list(string)
  default     = []
}

variable "single_nat_gateway" {
  description = "Provision a single shared NAT Gateway across all private subnets"
  type        = bool
  default     = false
}

######## EKS ########

variable "create_eks_cluster" {
  description = "Controls if EKS (managed Kubernetes) cluster should be created"
  type        = bool
  default     = false
}

variable "kubernetes_version" {
  description = "Kubernetes version for the EKS cluster (e.g. 1.33)"
  type        = string
  default     = null
}

variable "eks_deletion_protection" {
  description = "Whether to enable EKS deletion protection"
  type        = bool
  default     = null
}

variable "create_eks_cluster_cloudwatch_log_group" {
  description = "Whether to create a CloudWatch Log Group for EKS cluster logs"
  type        = bool
  default     = false
}

variable "eks_endpoint_private_access" {
  description = "Whether the EKS API endpoint is reachable from inside the VPC"
  type        = bool
  default     = true
}

variable "eks_endpoint_public_access" {
  description = "Whether the EKS API endpoint is reachable from the public internet"
  type        = bool
  default     = false
}

variable "eks_endpoint_public_access_cidrs" {
  description = "CIDR blocks allowed to reach the public EKS API endpoint (only used when eks_endpoint_public_access=true)"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "eks_control_plane_sg_additional_rules" {
  description = "Additional security group rules to add to the EKS control plane security group"
  type        = any
  default     = {}
}

variable "eks_authentication_mode" {
  description = "EKS authentication mode: CONFIG_MAP, API, or API_AND_CONFIG_MAP"
  type        = string
  default     = "API"

  validation {
    condition     = contains(["CONFIG_MAP", "API", "API_AND_CONFIG_MAP"], var.eks_authentication_mode)
    error_message = "eks_authentication_mode must be one of: CONFIG_MAP, API, API_AND_CONFIG_MAP."
  }
}

variable "eks_access_entries" {
  description = "Extra EKS Access Entries (AWS-side cluster access) used when authentication_mode is API or API_AND_CONFIG_MAP"
  type        = any
  default     = {}
}

variable "eks_access_entry_account_root_admin" {
  description = "Static EKS access entry object for account root admin (kept in tfvars)"
  type        = any
  default     = null
}

######## IRSA ########

variable "enable_irsa" {
  description = "Enable IRSA by creating an IAM OIDC provider for the EKS cluster"
  type        = bool
  default     = true
}

variable "openid_connect_audiences" {
  description = "Extra OIDC audiences to include on the IAM OIDC provider (sts.amazonaws.com is always included)"
  type        = list(string)
  default     = []
}

variable "include_oidc_root_ca_thumbprint" {
  description = "Include the OIDC root CA thumbprint"
  type        = bool
  default     = true
}

variable "custom_oidc_thumbprints" {
  description = "Additional OIDC server certificate thumbprints (rarely needed)"
  type        = list(string)
  default     = []
}

######## EKS Managed Node Group ########

variable "create_eks_managed_node_group" {
  description = "Controls if the EKS managed node group should be created"
  type        = bool
  default     = true
}

variable "node_group_instance_types" {
  description = "Instance types for the EKS managed node group"
  type        = list(string)
  default     = null
}

variable "node_group_min_size" {
  description = "Minimum number of nodes in the EKS managed node group"
  type        = number
  default     = null
}

variable "node_group_max_size" {
  description = "Maximum number of nodes in the EKS managed node group"
  type        = number
  default     = null
}

variable "node_group_desired_size" {
  description = "Desired number of nodes in the EKS managed node group"
  type        = number
  default     = null
}

variable "node_group_ebs_disk_size" {
  description = "Root EBS volume size (GiB) for EKS managed node group nodes"
  type        = number
  default     = null
}

variable "node_group_inputs_validation" {
  description = "Internal validation switch (do not set). Ensures required node group inputs are provided when creating EKS."
  type        = bool
  default     = true

  validation {
    condition = (
      var.create_eks_cluster == false || var.node_group_inputs_validation == false || (
        var.node_group_instance_types != null &&
        var.node_group_min_size != null &&
        var.node_group_max_size != null &&
        var.node_group_desired_size != null &&
        var.node_group_ebs_disk_size != null
      )
    )
    error_message = "When create_eks_cluster=true, you must set node_group_instance_types, node_group_min_size, node_group_max_size, node_group_desired_size, and node_group_ebs_disk_size (typically via prod-terraform.tfvars)."
  }
}

