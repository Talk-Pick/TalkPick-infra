variable "name_prefix" {
  description = "Talkpick default prefix"
  type        = string
  default     = "talkpick"
}

variable "bucket_name" {
  description = "S3 bucket name"
  type        = string
}

variable "region" {
  description = "Region name for vpc endpoint resource"
  type = string
}

variable "vpc_id" {
  description = "VPC id"
  type = string
}

variable "private_rt_ids" {
  description = "Connect endpoint to private routing tables"
  type = list(string)
}