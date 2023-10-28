module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "${local.name_prefix}-vpc"
  cidr = "10.17.0.0/16"

  azs = ["${local.region}a", "${local.region}c"]

  public_subnets  = ["10.17.0.0/20", "10.17.16.0/20"]
  private_subnets = ["10.17.128.0/20", "10.17.144.0/20"]

  enable_nat_gateway = true

  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }

  tags = {
    Name = "${local.name_prefix}-vpc"
  }
}