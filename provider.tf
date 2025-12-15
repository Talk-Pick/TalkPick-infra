terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  // ap-northeast-2 : Seoul
  region = "ap-northeast-2"
}