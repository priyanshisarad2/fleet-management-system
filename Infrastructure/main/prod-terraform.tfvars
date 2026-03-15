name         = "fleet-management-system"
project_name = "fleetman"
region       = "us-east-1"
env          = "prod"
account_id   = "331860160408"



########    Creation toggles (default: create nothing)    ########
# Turn individual services on by setting the corresponding flag to true.
create_vpc         = true
create_eks_cluster = false



########    VPC - Public and Private Subnets    ########
availability_zones = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
cidr               = "10.2.0.0/16"

# Public Subnets  - we need it for load balancer (for exposing webapp) and NAT Gateway (for private subnet to access internet)
public_subnets = [
  "10.2.1.0/24",
  "10.2.2.0/24"
]
public_subnet_names = [
  "fleetman-prod-public-subnet-1",
  "fleetman-prod-public-subnet-2"
]

# EKS cluster will be deployed in private subnets for better security
private_subnets = [
  "10.2.10.0/24",
  "10.2.11.0/24",
  "10.2.12.0/24",
  "10.2.13.0/24"
]
private_subnet_names = [
  "fleetman-prod-private-subnet-1",
  "fleetman-prod-private-subnet-2",
  "fleetman-prod-private-subnet-3",
  "fleetman-prod-private-subnet-4"
]

# NAT Gateway Configuration
# NAT gateway is used to allow private subnet to access internet (outbound internet access)
single_nat_gateway = true




########## EKS Cluster ##########
kubernetes_version                      = "1.34"
eks_deletion_protection                 = false

##########    CloudWatch Log Group    ##########
create_eks_cluster_cloudwatch_log_group = false


##########    Security Group    ##########
/*
  IMPORTANT: ensure the control-plane SG has egress so the control plane can reach kubelets on nodes.
  Without this, node groups can fail with NodeCreationFailure/Unhealthy nodes.
  This is not added by default - because of which cluster creation was failing
*/
eks_control_plane_sg_additional_rules = {
  egress_all = {
    type        = "egress"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    description = "Allow all egress from EKS control plane security group"
    cidr_blocks = ["0.0.0.0/0"]
  }
}



##########    Cluster Authentication    ##########
eks_authentication_mode = "API"

# Since the IAM user who created the cluster only has admin access to cluster
# I am giving the root account full admin access to this cluster as well
eks_access_entry_account_root_admin = {
  principal_arn = "arn:aws:iam::331860160408:root"

  # Remember that even though root account has access to entire AWS - but it will not automatically will have access to eks cluster

  # Which is why I am creating access entry for it - and associating a cluster access policy to it
  policy_associations = {
    admin = {
      policy_arn = "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy"
      access_scope = {
        type = "cluster"
      }
    }
  }
}

eks_endpoint_private_access      = true # for worker nodes to join
eks_endpoint_public_access       = true # for me
eks_endpoint_public_access_cidrs = ["0.0.0.0/0"]



##########    IRSA (IAM Roles for Service Accounts)    ##########
enable_irsa = true
# Extra OIDC audiences; the EKS module always includes "sts.amazonaws.com" by default for IRSA.
openid_connect_audiences = []
# Keep true: auto-detect and include the OIDC root CA thumbprint for the IAM OIDC provider.
include_oidc_root_ca_thumbprint = true
# Rarely needed: additional OIDC server cert thumbprints (leave empty unless you have a custom TLS chain).
custom_oidc_thumbprints = []




##########    EKS Managed Node Group    ##########
node_group_instance_types = ["t3a.small"]
node_group_min_size       = 3
node_group_max_size       = 3
node_group_desired_size   = 3
node_group_ebs_disk_size  = 20


