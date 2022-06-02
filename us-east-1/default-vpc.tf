terraform {
  cloud {
    organization = "esg_se_xdr_demo_environment"
    workspaces {
      tags = ["aws_region:us-east-1"]
    }
  }
}

provider "aws" {
  region = ""
}

provider "aws" {
  region = "us-west-1"
  alias  = "usw1"
}

provider "aws" {
  region = "us-west-2"
  alias  = "usw2"
}

provider "aws" {
  region = "us-east-1"
  alias  = "use1"
}

provider "aws" {
  region = "us-east-2"
  alias  = "use2"
}

locals {
  import_date = formatdate("MM-DD-YYYY", timestamp())
  default_tags = {
    managed_by  = "Terraform"
    is_default  = "true"
    import_date = local.import_date
  }
}

module "default_vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "3.14.0"
  # insert the 23 required variables here
  providers = {
    aws = aws.use1
  }
  create_vpc                       = false
  manage_default_vpc               = true
  default_vpc_name                 = "default"
  default_vpc_enable_dns_hostnames = true
  tags = merge(
    local.default_tags
  )
}
