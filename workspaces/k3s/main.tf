terraform {
  backend "s3" {}
}


data "aws_region" "current" {}
data "aws_availability_zones" "all" {}

# ----------------------------------------------
# Networking
# ----------------------------------------------

module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = var.cluster_id
  cidr = var.vpc_cidr

  azs                  = data.aws_availability_zones.all.names
  private_subnets      = var.private_subnets
  public_subnets       = var.public_subnets
  enable_dns_hostnames = true
  enable_dns_support   = true

  # optionally,
  enable_nat_gateway = true
  single_nat_gateway = true # perhaps you got money to burn?

  #tags = var.tags
}

# ----------------------------------------------
# Main module
# ----------------------------------------------

module "k3s-in-new-vpc" {
  source = "sagittaros/private-cloud/k3s"

  # main
  cluster_id = var.cluster_id

  # networking
  region             = data.aws_region.current.name
  availability_zones = data.aws_availability_zones.all.names
  vpc_id             = module.vpc.vpc_id
  public_subnets     = module.vpc.public_subnets
  private_subnets    = module.vpc.private_subnets

  # node instances
  master_instance_type = var.master_instance_type 
  node_count           = 5
  node_instance_arch   = "x86_64"
  node_instance_types  = ["t3a.small", "t3.small"]
  on_demand_percentage = 0 # all spot instances

  # # run on Arm architecture, where g == ARM-based graviton
  # node_instance_arch   = "arm64"
  # node_instance_type   = "r6g.medium"
}

