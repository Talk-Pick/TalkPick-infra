output "vpc_id" {
  value = aws_vpc.talkpick_vpc.id
}

output "public_subnet_ids" {
  value = aws_subnet.talkpick_public_sn[*].id
}

output "private_subnet_ids" {
  value = aws_subnet.talkpick_private_sn[*].id
}

output "private_route_table_ids" {
  value = aws_route_table.talkpick_private_rt[*].id
}

output "public_subnets_cidr" {
  value = aws_subnet.talkpick_public_sn[*].cidr_block
}