variable "tags" {
  type = map(string)
}


variable "cluster_id" {
  type    = string
  default = "k3s-cluster"
}


variable "master_instance_type" {
  type    = string
  default = "t3a.small"
}


variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "private_subnets" {
  type    = list(string)
  default =  ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}


variable "public_subnets" {
  type    = list(string)
  default =  ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]
}



