terraform {
  source = "../../..//workspaces/k3s-arm"
}

include {
  path = find_in_parent_folders()
}

locals {
  common_vars = yamldecode(file("../../common_vars.yaml"))
}

inputs = {
  tags = local.common_vars.tags
}
