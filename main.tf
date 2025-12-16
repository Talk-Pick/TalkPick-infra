// Environments
locals {
  vpc={
    cidr: "10.1.0.0/16",
    public_cidrs: [
      "10.1.0.0/24",
      "10.1.1.0/24"
    ],
    private_cidrs: [
      "10.1.2.0/24",
      "10.1.3.0/24"
    ],
    availability_zones: [
      "ap-northeast-2a",
      "ap-northeast-2b"
    ]
  }
}

// VPC Module
module "vpc" {
  // refer ./terraform-vpc module
  source = "./terraform-vpc"

  // environments from locals
  vpc_cidr = local.vpc.cidr
  public_subnet_cidrs = local.vpc.public_cidrs
  private_subnet_cidrs = local.vpc.private_cidrs
  availability_zones = local.vpc.availability_zones
}