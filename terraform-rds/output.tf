// Review Output
output "talkpick_rds_output" {
  description = "Output talkpick RDS info"
  value = {
    rds_instance_name = aws_db_instance.talkpick_private_rds.identifier
    rds_endpoint      = aws_db_instance.talkpick_private_rds.endpoint
    rds_username      = aws_db_instance.talkpick_private_rds.db_name
    rds_port          = aws_db_instance.talkpick_private_rds.port
  }
}