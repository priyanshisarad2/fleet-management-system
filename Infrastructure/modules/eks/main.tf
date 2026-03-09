###  EKS Setup  ###

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "21.15.1"
  create  = var.create_eks_cluster
  region  = var.eks_region
  name    = var.eks_cluster_name

  # IRSA (OIDC provider for service account -> IAM role)
  enable_irsa                     = var.enable_irsa
  openid_connect_audiences         = var.openid_connect_audiences
  include_oidc_root_ca_thumbprint  = var.include_oidc_root_ca_thumbprint
  custom_oidc_thumbprints          = var.custom_oidc_thumbprints


  #### Cluster settings ####
  kubernetes_version   = var.kubernetes_version
  deletion_protection  = var.eks_deletion_protection
  force_update_version = false


  # upgrade_policy controls STANDARD vs EXTENDED support; null = use EKS default (STANDARD)
  upgrade_policy = var.eks_control_plane_upgrade_policy


  vpc_id                   = var.eks_vpc_id

  # This is where EKS cluster control plane (ENIs) will be provisioned
  control_plane_subnet_ids = var.eks_control_plane_subnet_ids

  # This is where EKS node group (EC2 instances and its ENIs) will be provisioned
  subnet_ids               = var.eks_node_group_subnet_ids


  #### Cluster OR Control Plane Security Group ####
  # SG: EKS creates a primary SG by default for control-plane / cluster
  # doing below to give it a name
  # we can add additional rules to it
  # eks obviously add some rules on its own
  create_security_group          = true
  security_group_name            = var.control_plane_sg_name
  security_group_use_name_prefix = false

  # IMPORTANT: ensure the control-plane SG has egress so the control plane can reach kubelets on nodes.
  # Without this, node groups can fail with NodeCreationFailure/Unhealthy nodes.
  # THis is not added by default
  security_group_additional_rules = var.eks_control_plane_sg_additional_rules


  create_cloudwatch_log_group = var.eks_cluster_cloudwatch_log_group


  # Private API endpoint ON (access EKS API from inside VPC, e.g., via bastion/VPN/SSM)
  endpoint_private_access = var.eks_endpoint_private_access
  # Public API endpoint OFF (no direct internet access to EKS API)
  endpoint_public_access = var.eks_endpoint_public_access

  # If endpoint_public_access=true, restrict who can reach the public EKS API (e.g., office public IP). Ignored when endpoint_public_access=false.
  endpoint_public_access_cidrs = var.eks_endpoint_public_access_cidrs
  /*
    For production, it is good to not allow direct public API access to cluster. Instead create a bastion host, install kubectl in it - and access it from there.

    For my testing - I will access it publicly from my local machine.
  */

  # ip_family: chooses whether pods/services use IPv4 (common) or IPv6 addresses (must be decided at cluster creation)
  ip_family = var.eks_ip_family
  # service_ipv4_cidr: the IPv4 range used for Kubernetes Service (ClusterIP) IPs CIDR; leave null to let EKS pick the default
  service_ipv4_cidr = var.eks_service_ipv4_cidr



  authentication_mode = var.eks_authentication_mode
  /*
  authentication_mode = how EKS decides who can access the cluster.

  - CONFIG_MAP: old way. You edit the in-cluster `aws-auth` ConfigMap to add IAM users/roles and their Kubernetes groups.
  - API: new way (recommended) You create EKS "Access Entries" in AWS for an IAM user/role and attach admin/view policies. You do NOT edit `aws-auth`. Instead you tell AWS:
    1) "This IAM user/role can access this cluster" (Access Entry)
    2) "This is their permission level" (attach an EKS access policy like Admin/View)
  - API_AND_CONFIG_MAP: hybrid. Both Access Entries + `aws-auth` ConfigMap are used (good for migration).
  */


  access_entries = var.eks_access_entries
  /*
   Access Entries = AWS-side list of who can access this cluster and what permissions they get (used in API modes)

   Eg: if you want to give read access of cluster to developers
  */


  # Gives the IAM identity running Terraform (you) admin access to cluster via an EKS Access Entry
  enable_cluster_creator_admin_permissions = true

  # EKS Auto Mode (compute_config) disabled for now
  compute_config = {
    enabled = false
  }

  # Extra tags only for the EKS cluster resource (not all resources)
  cluster_tags = var.eks_cluster_tags


  # IAM role of cluster / control-plane settings pending
  create_iam_role          = true # true by default
  iam_role_name            = var.eks_control_plane_iam_role_name
  iam_role_use_name_prefix = false

  #### Cluster Config ends here ####



  #### Node Group  ####
  create_node_security_group          = true
  node_security_group_name            = var.eks_node_group_sg_name
  node_security_group_use_name_prefix = false

  addons = var.eks_addons

  # EKS Managed Node Groups (simple/default node group config goes here)
  eks_managed_node_groups = var.eks_managed_node_groups


  # Global tags
  tags = var.eks_tags
}