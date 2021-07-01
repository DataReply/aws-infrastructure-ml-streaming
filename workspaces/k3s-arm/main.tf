terraform {
  backend "s3" {}
}


data "aws_region" "current" {}
data "aws_availability_zones" "all" {}


data "aws_vpcs" "vpc" {
  tags = {
    Name  = var.host_cluster_name
  }
}

locals {
  vpc_id = sort(data.aws_vpcs.vpc.ids)[0]
}

data "aws_subnet_ids" "public" {
  vpc_id = local.vpc_id
  filter {
    name   = "tag:kubernetes.io/cluster/k3s-cluster"
    values = ["shared"] # insert values here
  }
}

data "aws_subnet_ids" "private" {
  vpc_id = local.vpc_id
  filter {
    name   = "tag:Name"
    values = [ format("%s-private-eu-central-1a", var.host_cluster_name), format("%s-private-eu-central-1b", var.host_cluster_name), format("%s-private-eu-central-1c", var.host_cluster_name)] 
  }
}

module "k3s-in-existing-vpc" {
  source = "sagittaros/private-cloud/k3s"
  # main
  cluster_id = var.cluster_id

  # networking
  region             = data.aws_region.current.name
  availability_zones = data.aws_availability_zones.all.names
  vpc_id             = local.vpc_id
  public_subnets     = sort(data.aws_subnet_ids.public.ids)
  private_subnets    = sort(data.aws_subnet_ids.private.ids)

  # node instances
  node_count           = 4
  on_demand_percentage = 0 # all spot instances

  node_instance_arch   = "arm64"
  master_instance_type = var.master_instance_type 
  node_instance_types  = ["t4g.small", "t4g.medium", "r6g.medium" ]
}