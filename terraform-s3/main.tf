// S3 Bucket
resource "aws_s3_bucket" "talkpick_bucket" {
  // bucket name
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_name
  }
}

// Block all public access
resource "aws_s3_bucket_public_access_block" "talkpick_bucket_public_block" {
  bucket = aws_s3_bucket.talkpick_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

// VPC Endpoint to S3
resource "aws_vpc_endpoint" "talkpick_s3_endpoint" {
  // config for vpc endpoint
  vpc_id            = var.vpc_id
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  // connect to private rt
  route_table_ids = var.private_rt_ids

  tags = {
    Name = "${var.name_prefix}-s3-endpoint"
  }
}