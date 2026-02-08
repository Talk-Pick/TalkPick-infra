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
  iam = {
    ssm_instance_role_name = "talkpick-ec2-ssm-role"
  }
  ec2={
    sg_name: "SG-ALLOW_SSH_HTTPS"
    region: "ap-northeast-2"
  }
  s3 = {
    name : "talkpick-static-assets-1"
    region: "ap-northeast-2"
  }
  rds={
    db_name: "talkpick_db"
    db_port: 3306
    instance_class: "db.t3.micro"
  }
}

data "aws_caller_identity" "current" {}

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
  vpc_id         = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids

  // from terraform-ec2
  ec2_private_ips = module.ec2.ec2_private_ips
}

// EC2 Module 
module "ec2" {
  // refer ./terraform-ec2 module
  source = "./terraform-ec2"
  
  // environments from locals
  sg_name = local.ec2.sg_name

  // from terraform-vpc
  vpc_id = module.vpc.vpc_id
  public_subnets_cidr = module.vpc.public_subnets_cidr
  private_subnet_ids  = module.vpc.private_subnet_ids
  aws_region = local.ec2.region
  aws_account_id  = data.aws_caller_identity.current.account_id
}

// S3 Module
module "s3" {
  // refer ./terraform-s3 module
  source = "./terraform-s3"

  // environments from locals
  bucket_name    = local.s3.name
  region         = local.s3.region

  // from terraform-vpc   
  vpc_id         = module.vpc.vpc_id
  private_rt_ids = module.vpc.private_route_table_ids
}

// RDS Module
module "rds" {
  // refer ./terraform-rds module
  source = "./terraform-rds"

  // environments from locals
  vpc_cidr    = local.vpc.cidr
  instance_class = local.rds.instance_class
  db_name     = local.rds.db_name
  db_port     = local.rds.db_port

  // environtments from variable
  db_username = var.db_username
  db_password = var.db_password

  // from terraform-vpc
  vpc_id      = module.vpc.vpc_id
  subnet_ids = module.vpc.private_subnet_ids

  // from terraform-ec2
  ec2_security_group_id = module.ec2.ec2_security_group_id
}