#---networking/outputs.tf---

output "public_subnets" {
  value = aws_subnet.krypt0_22_public_subnet.*.id
}

output "vpc_id" {
  value = aws_vpc.krypt0_22_vpc.id
}