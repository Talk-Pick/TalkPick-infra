output "talkpick_s3_bucket_output" {
  description = "Output talkpick s3 bucket info"
  value       = {
    s3_bucket_arn = aws_s3_bucket.talkpick_bucket.arn
    s3_bucket_domain = aws_s3_bucket.talkpick_bucket.bucket_domain_name
  }
}

output "talkpick_s3_endpoint_output"{
  description = "Output talkcpick s3 endpoint info"
  value = {
    vpc_endpoint_arn = aws_vpc_endpoint.talkpick_s3_endpoint.arn
    vpc_endpoint_service = aws_vpc_endpoint.talkpick_s3_endpoint.service_name
    vpc_endpoint_type = aws_vpc_endpoint.talkpick_s3_endpoint.vpc_endpoint_type
    vpc_endpoint_route_table_ids = aws_vpc_endpoint.talkpick_s3_endpoint.route_table_ids
    vpc_endpoint_tags = aws_vpc_endpoint.talkpick_s3_endpoint.tags["Name"]
  }
}