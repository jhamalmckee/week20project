#---networking/main.tf---

data "aws_availability_zones" "available" {}

resource "random_pet" "random" {}

resource "random_shuffle" "az_list" {
  input = data.aws_availability_zones.available.names
}

resource "aws_vpc" "krypt0_22_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "krypt0_22_vpc_${random_pet.random.id}"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_subnet" "krypt0_22_public_subnet" {
  count                   = var.public_subnet_count
  vpc_id                  = aws_vpc.krypt0_22_vpc.id
  cidr_block              = var.public_cidrs[count.index]
  map_public_ip_on_launch = true
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "krypt0_22_public_subnet_${count.index + 1}"
  }
}

resource "aws_subnet" "krypt0_22_private_subnet" {
  count                   = var.private_subnet_count
  vpc_id                  = aws_vpc.krypt0_22_vpc.id
  cidr_block              = var.private_cidrs[count.index]
  map_public_ip_on_launch = false
  availability_zone       = random_shuffle.az_list.result[count.index]

  tags = {
    Name = "krypt0_22_private_subnet_${count.index + 1}"
  }
}

resource "aws_route_table_association" "krypt0_public_association" {
  count          = var.public_subnet_count
  subnet_id      = aws_subnet.krypt0_22_public_subnet.*.id[count.index]
  route_table_id = aws_route_table.krypt0_22_public_rt.id
}

resource "aws_route_table_association" "krypt0_private_association" {
  count          = var.private_subnet_count
  subnet_id      = aws_subnet.krypt0_22_private_subnet.*.id[count.index]
  route_table_id = aws_route_table.krypt0_22_private_rt.id
}

resource "aws_route_table" "krypt0_22_public_rt" {
  vpc_id = aws_vpc.krypt0_22_vpc.id

  tags = {
    Name = "krypt0_22_public_rt"
  }
}

resource "aws_route_table" "krypt0_22_private_rt" {
  vpc_id = aws_vpc.krypt0_22_vpc.id

  tags = {
    Name = "krypt0_22_private_rt"
  }
}

resource "aws_internet_gateway" "krypt0_22_internet_gateway" {
  vpc_id = aws_vpc.krypt0_22_vpc.id

  tags = {
    Name = "krypt0_22_internet_gateway"
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_eip" "krypt0_22_eip" {}

resource "aws_nat_gateway" "krypt0_22_nat_gateway" {
  allocation_id = aws_eip.krypt0_22_eip.id
  subnet_id     = aws_subnet.krypt0_22_public_subnet[1].id
}

resource "aws_route" "krypt0_22_default_public_route" {
  route_table_id         = aws_route_table.krypt0_22_public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.krypt0_22_internet_gateway.id
}

resource "aws_route" "krypt0_22_default_private_route" {
  route_table_id         = aws_route_table.krypt0_22_private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.krypt0_22_nat_gateway.id
}

resource "aws_default_route_table" "krypt0_22_private_rt" {
  default_route_table_id = aws_vpc.krypt0_22_vpc.default_route_table_id

  tags = {
    Name = "krypt0_22_private_rt"
  }
}