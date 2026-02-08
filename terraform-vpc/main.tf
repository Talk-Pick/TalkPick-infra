// VPC
resource "aws_vpc" "talkpick_vpc" {
  cidr_block           = var.vpc_cidr  // vpc cidr
  enable_dns_hostnames = true          // allow dns(public subnet)

  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

// VPC IGW
resource "aws_internet_gateway" "talkpick_igw" {
  vpc_id = aws_vpc.talkpick_vpc.id  // get vpc id

  tags = {
    Name = "${var.name_prefix}-igw"
  }
}

// VPC NAT EIP
resource "aws_eip" "talkpick_nat_eip" {
  // loop
  count  = length(var.private_subnet_cidrs)

  // config for eip
  domain = "vpc"

  tags = {
    Name = "${var.name_prefix}-nat-eip-${count.index + 1}"
  }
}

// VPC NAT GW
resource "aws_nat_gateway" "talkpick_nat_gw" {
  // loop
  count         = length(var.private_subnet_cidrs)

  // config for nat gateway
  allocation_id = aws_eip.talkpick_nat_eip[count.index].id
  subnet_id     = aws_subnet.talkpick_public_sn[count.index].id

  tags = {
    Name = "${var.name_prefix}-nat-gw-${count.index + 1}"
  }

  depends_on = [aws_internet_gateway.talkpick_igw]
}


// Public Subnet
resource "aws_subnet" "talkpick_public_sn" {
  // loop
  count                   = length(var.public_subnet_cidrs)

  // config for public subnet
  vpc_id                  = aws_vpc.talkpick_vpc.id  // get vpc id
  cidr_block              = var.public_subnet_cidrs[count.index]
  availability_zone       = var.availability_zones[count.index]

  tags = {
    Name = "${var.name_prefix}-public-sn-${count.index + 1}"
  }
}

// VPC Private Subnet
resource "aws_subnet" "talkpick_private_sn" {
  // loop
  count             = length(var.private_subnet_cidrs)

  // config for private subnet
  vpc_id            = aws_vpc.talkpick_vpc.id
  cidr_block        = var.private_subnet_cidrs[count.index]
  availability_zone = var.availability_zones[count.index]

  tags = {
    Name = "${var.name_prefix}-private-sn-${count.index + 1}"
  }
}

// VPC Public RT
resource "aws_route_table" "talkpick_public_rt" {
  vpc_id = aws_vpc.talkpick_vpc.id  // get vpc id

  // config for public routing table
  route {
    cidr_block = "0.0.0.0/0"  // default routing to igw
    gateway_id = aws_internet_gateway.talkpick_igw.id
  }

  tags = {
    Name = "${var.name_prefix}-public-rt"
  }
}

// VPC Public RT Association
resource "aws_route_table_association" "talkpick_public_rt_association" {
  // loop
  count          = length(var.public_subnet_cidrs)

  // config for public routing table association
  subnet_id      = aws_subnet.talkpick_public_sn[count.index].id
  route_table_id = aws_route_table.talkpick_public_rt.id
}

// VPC Private RT
resource "aws_route_table" "talkpick_private_rt" {
  // loop
  count  = length(var.private_subnet_cidrs)

  vpc_id = aws_vpc.talkpick_vpc.id  // get vpc id

  // config for private rt
  route {
    cidr_block     = "0.0.0.0/0"  // default routing to nat gateway
    nat_gateway_id = aws_nat_gateway.talkpick_nat_gw[count.index].id
  }

  tags = {
    Name = "${var.name_prefix}-private-rt-${count.index + 1}"
  }
}

// VPC Private RT Association
resource "aws_route_table_association" "talkpick_private_rt_association" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = aws_subnet.talkpick_private_sn[count.index].id
  route_table_id = aws_route_table.talkpick_private_rt[count.index].id
}