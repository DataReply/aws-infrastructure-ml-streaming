variable "tags" {
  type = map(string)
}


variable "cluster_id" {
  type    = string
  default = "k3s-arm-cluster"
}


# master is x64
variable "master_instance_type" {
  type    = string
  default = "t3a.small"
}


variable "host_cluster_name" {
  type    = string
  default = "k3s-cluster"
}


