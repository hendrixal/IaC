# main.tf file for VPC Module

# create vpc using the output values defined in outputs.tf

resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

# create public subnet for ec2 webserver

resource "aws_subnet" "public_sub_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_cidr_block
  availability_zone = var.public_avaliblity_zone_1
}


# create first private subnet for RDS subnet group
# RDS requires 2 subnets in different avalibility zones


resource "aws_subnet" "private_sub_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_cidr_block_1
  availability_zone = var.private_avaliblity_zone_1
}

# create second private subnet for RDS subnet group

resource "aws_subnet" "private_sub_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_cidr_block_2
  availability_zone = var.private_avaliblity_zone_2
}


# create internet gateway to provide vpc access to the internet.

resource "aws_internet_gateway" "int_gateway" {
  vpc_id = aws_vpc.vpc.id
}


# create elasitc ip address to set to internet gateway
# we want to keep the internet gateway ip address static so that resources within the vpc know the default gateway address.

resource "aws_eip" "elastic_ip_gateway" {
  vpc        = true
  depends_on = [aws_internet_gateway.int_gateway]
}


# create public route table and use 0.0.0.0/0 for all ipv4 addresses and use the above internet gateway.

resource "aws_route" "route-public" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.int_gateway.id
}




# create nat gateway to connect to resources on private subnets

resource "aws_nat_gateway" "gateway" {
  subnet_id     = aws_subnet.public_sub_1.id
  allocation_id = aws_eip.elastic_ip_gateway.id
}

# create private route table to vpc 

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gateway.id
  }
}

# create route public table rule to associate to public subnet

resource "aws_route_table_association" "public-rt" {
  subnet_id      = aws_subnet.public_sub_1.id
  route_table_id = aws_vpc.vpc.main_route_table_id
}

# create route table rule to assoicate to private subnet 1

resource "aws_route_table_association" "private_sub1" {
  subnet_id      = aws_subnet.private_sub_1.id
  route_table_id = aws_route_table.private-rt.id
}

# create route table rule to assoicate to private subnet 2

resource "aws_route_table_association" "private_sub2" {
  subnet_id      = aws_subnet.private_sub_2.id
  route_table_id = aws_route_table.private-rt.id
}
