#---networking/outputs.tf---

output "public_subnets" {
  value = aws_subnet.week20_public_subnet.*.id
}

output "vpc_id" {
  value = aws_vpc.week20_vpc.id
}
