########     VPC     ########
module "vpc" {
  source                       = "../modules/vpc"
  create_vpc                   = var.create_vpc
  name                         = "${var.project_name}-${var.env}"
  app                          = "vpc"
  cidr                         = var.cidr
  availability_zones           = var.availability_zones
  public_subnets               = var.public_subnets
  public_subnet_names          = var.public_subnet_names
  private_subnets              = var.private_subnets
  private_subnet_names         = var.private_subnet_names
  create_database_subnet_group = true
  database_subnets             = var.database_subnets
  database_subnet_names        = var.database_subnet_names
  database_subnet_group_name   = "${var.project_name}-${var.env}-database-subnet-group"
  single_nat_gateway           = var.single_nat_gateway
}