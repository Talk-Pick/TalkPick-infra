variable "name_prefix" {
  description = "Talkpick default prefix"
  type        = string
  default     = "talkpick"
}

variable "vpc_id" {
  description = "VPC id"
  type = string
}

variable "private_subnet_ids" {
  description = "VPC Private Subnets ID"
  type        = list(string)
  default     = []
}

variable "public_subnets_cidr" {
    description = "VPC Public Subnet CIDR"
    type = list(string)
    default = []
}

variable "sg_name" {
  description = "Security group name for ec2"
  type = string
}

variable "ec2_instance_profile" {
  type = string
}
