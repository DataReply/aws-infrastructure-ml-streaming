remote_state {
  backend = "s3"
  config = {
    bucket         = "datareply-demo-dev-tfstate"
    key            = "${path_relative_to_include()}/terraform.tfstate"
    region         = "eu-central-1"
    encrypt        = true
    profile        = "datareply"
    dynamodb_table = "terraform-locks"
  }
}

##  https://github.com/gruntwork-io/terragrunt-infrastructure-live-example/blob/master/terragrunt.hcl
# Generate an AWS provider block
generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "aws" {
  region   = "eu-central-1"
  profile        = "datareply"
}
EOF
}


