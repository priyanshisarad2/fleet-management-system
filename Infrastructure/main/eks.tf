####  EKS  ####

module "eks" {
  source             = "../modules/eks"
  create_eks_cluster = var.create_eks_cluster
  eks_region         = var.region
  eks_cluster_name   = "${var.project_name}-eks-cluster"

  # IRSA
  enable_irsa                     = var.enable_irsa
  openid_connect_audiences        = var.openid_connect_audiences
  include_oidc_root_ca_thumbprint = var.include_oidc_root_ca_thumbprint
  custom_oidc_thumbprints         = var.custom_oidc_thumbprints


  #####   Cluster settings   #####
  kubernetes_version      = var.kubernetes_version
  eks_deletion_protection = var.eks_deletion_protection
  eks_vpc_id              = module.vpc.vpc_id

  # Both control-plane and node-group should be launched in private subnet
  eks_control_plane_subnet_ids = module.vpc.private_subnet_ids  # This is where EKS cluster control plane (ENIs) will be provisioned
  eks_node_group_subnet_ids    = module.vpc.private_subnet_ids  # This is where EKS node group (EC2 instances and its ENIs) will be provisioned

  # Control plane upgrade support policy
  eks_control_plane_upgrade_policy = {
    support_type = "STANDARD"
  }

  eks_cluster_cloudwatch_log_group = var.create_eks_cluster_cloudwatch_log_group


  #### Cluster OR Control Plane Security Group ####
  control_plane_sg_name            = "${var.project_name}-eks-control-plane"

  # Extra SG rules for control plane SG (defined in tfvars)
  eks_control_plane_sg_additional_rules = var.eks_control_plane_sg_additional_rules
  

  # IAM Role for EKS cluster (control plane)
  eks_control_plane_iam_role_name = "${var.project_name}-eks-control-plane"

  # Endpoint access (API endpoint)
  eks_endpoint_private_access      = var.eks_endpoint_private_access
  eks_endpoint_public_access       = var.eks_endpoint_public_access
  eks_endpoint_public_access_cidrs = var.eks_endpoint_public_access_cidrs


  # Networking
  eks_ip_family         = "ipv4"
  eks_service_ipv4_cidr = null


  # Access (API auth mode)
  eks_authentication_mode = var.eks_authentication_mode
  eks_access_entries = merge(
    # Static root admin entry (from tfvars)
    var.eks_access_entry_account_root_admin != null ? { account_root_admin = var.eks_access_entry_account_root_admin } : {},

    # Optional extra entries
    var.eks_access_entries
  )


  # Tags
  # Cluster-only tags are set here (not in tfvars)
  eks_cluster_tags = {
    Project     = var.project_name
    Environment = var.env
    Terraform   = "true"
  }
  # Global tags applied to all resources created by the EKS module
  eks_tags = {
    Project     = var.project_name
    Environment = var.env
    Terraform   = "true"
  }

  ####  EKS Add-ons  ###
  eks_addons = {
    coredns = {}
    eks-pod-identity-agent = {
      before_compute = true
    }
    kube-proxy = {}
    vpc-cni = {
      # before_compute = true (inside your vpc-cni add-on config) tells the official terraform-aws-eks module to install/activate that EKS managed add-on before it creates any compute, i.e. before your managed node group instances are provisioned.
      # For vpc-cni, this is important because the nodes need the CNI components (aws-node DaemonSet) to come up so the node can become Ready and pods can get networking/IPs.
      before_compute = true
      # Avoid rollbacks when IaC meets an existing/default add-on configuration.
      resolve_conflicts_on_create = "OVERWRITE"
      resolve_conflicts_on_update = "OVERWRITE"
      # Don't accidentally remove pod networking from a live cluster.
      preserve = true
    }
  }


  #### Managed Node Group  ####
  eks_node_group_sg_name = "${var.project_name}-eks-node-group"

  eks_managed_node_groups = {
    fleetman-node-group = {
      # Allow temporarily disabling node group creation (e.g., during cluster/KMS imports)
      create         = var.create_eks_managed_node_group
      name           = "${var.project_name}-eks-node-group"
      instance_types = var.node_group_instance_types
      min_size       = var.node_group_min_size
      max_size       = var.node_group_max_size
      desired_size   = var.node_group_desired_size
      disk_size      = var.node_group_ebs_disk_size
      force_delete   = true

      tags = {
        Name = "worker" # name of ec2 instance of managed node group
      }

      # Let the module generate bootstrap user data so nodes join the EKS cluster
      enable_bootstrap_user_data = true

      # Node Group ASG - Launch Template
      create_launch_template          = true
      launch_template_name            = "${var.project_name}-eks-managed-node-group"
      launch_template_use_name_prefix = false
      ebs_optimized                   = true
      disable_api_termination         = false # ec2 termination protection


      # IAM Role
      create_iam_role          = true
      iam_role_name            = "${var.project_name}-eks-managed-node-group"
      iam_role_use_name_prefix = false
      # Critical for aws-node (VPC CNI) to attach secondary ENIs / assign pod IPs.
      # AWS official guidance calls this out as a common root cause of CNI/network plugin failures.
      iam_role_attach_cni_policy = true


      # Security Group
      create_security_group          = true
      security_group_name            = "${var.project_name}-eks-managed-node-group"
      security_group_use_name_prefix = false



      # EKS creates a SG for node-group - so we don't generally have to attach the cluster's primary SG to node-group
      attach_cluster_primary_security_group = false
    }
  }
}