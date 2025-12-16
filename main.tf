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
  nlb={
    name: "talkpick-nlb",
    tg_name: "talkpick-nlb-tg",
    target_port: 80,
    listener_port: 80
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

// NLB Module
module "nlb" {
  // refer ./terraform-nlb module
  source = "./terraform-nlb"

  // environments from locals
  nlb_name       = local.nlb.name         // nlb name
  target_name        = local.nlb.tg_name  // target group name
  target_port    = local.nlb.target_port
  listener_port    = local.nlb.listener_port

  // from terraform-vpc
  vpc_id         = module.terraform-vpc-aws.talkpick_vpc_id
  public_subnet_ids = module.terraform-vpc-aws.talkpick_public_subnet_ids

  // from terraform-ec2
  ec2_private_ips = module.terraform-ec2.talkpick_private_ec2_private_ips
}
