# Configure the AWS Provider
provider "aws" {
    alias = "us-east-1"
    region = "us-east-1"
}

# Configure the AWS Provider
provider "aws" {
  alias = "us-west-2"
  region = "us-west-2"
}

data "aws_availability_zones" "available_us-east-1" {
    provider = aws.us-east-1
}

data "aws_availability_zones" "available_us-west-2" {
    provider = aws.us-west-2
}

locals {
  name   = "ex-${basename(path.cwd)}"
  region = var.main.region

  vpc_cidr = "10.0.0.0/16"
  azs_us-east-1     = slice(data.aws_availability_zones.available_us-east-1.names, 0, 2)
  azs_us-west-2      = slice(data.aws_availability_zones.available_us-west-2.names, 0, 2)

  tags = {
    virginia = var.tags_virginia
    oregon   = var.tags_oregon
  }
}

module "vpc_virginia" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"
  providers = {
    aws = aws.us-east-1
  }

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs_us-east-1
  private_subnets = [for k, v in local.azs_us-east-1 : cidrsubnet(local.vpc_cidr, 2, k)]
  public_subnets = [for k, v in local.azs_us-east-1 : cidrsubnet(local.vpc_cidr, 2, k+2)]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags.virginia
}

module "vpc_oregon" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.8.1"
  providers = {
    aws = aws.us-west-2
  }

  name = local.name
  cidr = local.vpc_cidr

  azs             = local.azs_us-west-2
  private_subnets = [for k, v in local.azs_us-west-2 : cidrsubnet(local.vpc_cidr, 2, k)]
  public_subnets = [for k, v in local.azs_us-west-2 : cidrsubnet(local.vpc_cidr, 2, k+2)]

  enable_nat_gateway = true
  single_nat_gateway = true

  tags = local.tags.oregon
}