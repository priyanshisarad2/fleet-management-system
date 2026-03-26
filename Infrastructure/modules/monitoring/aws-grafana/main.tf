# AWS Managed Grafana

module "managed-service-grafana" {
  source  = "terraform-aws-modules/managed-service-grafana/aws"
  version = "2.3.1"

  create           = var.create_grafana
  create_workspace = var.create_grafana
  grafana_version  = var.grafana_version


  ### Workspace Settings ###
  name        = var.workspace_name
  description = var.workspace_description


  account_access_type = var.account_access_type
  # The option is "CURRENT_ACCOUNT" or "ORGANIZATION"

  permission_type = var.permission_type
  # For this setup, keep "SERVICE_MANAGED" so AWS manages the workspace IAM wiring.

  authentication_providers = var.authentication_providers
  # This controls how users log in to the Grafana workspace.
  # For this setup, keep "AWS_SSO" unless you specifically need SAML-based login.

  data_sources = var.data_sources
  # This controls the data sources that are available in the Grafana workspace.
  # Valid values are `AMAZON_OPENSEARCH_SERVICE`, `ATHENA`, `CLOUDWATCH`, `PROMETHEUS`, `REDSHIFT`, `SITEWISE`, `TIMESTREAM`, `XRAY`

  role_associations = var.role_associations
  # Map IAM Identity Center users/groups to Grafana ADMIN, EDITOR, or VIEWER roles.

  network_access_control = var.network_access_control

  associate_license = var.associate_license
  # Keep this false unless you intentionally want Grafana Enterprise licensing.


  tags = var.tags
}