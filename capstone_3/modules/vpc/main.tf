resource "aws_vpc" "vpc" {
  cidr_block       = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_sub_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.public_cidr_block
  availability_zone = var.public_avaliblity_zone_1
}


resource "aws_subnet" "private_sub_1" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_cidr_block_1
  availability_zone = var.private_avaliblity_zone_1
}



resource "aws_subnet" "private_sub_2" {
  vpc_id     = aws_vpc.vpc.id
  cidr_block = var.private_cidr_block_2
  availability_zone = var.private_avaliblity_zone_2
}



resource "aws_internet_gateway" "int_gateway" {
  vpc_id = aws_vpc.vpc.id
}



resource "aws_route" "route-public" {
  route_table_id         = aws_vpc.vpc.main_route_table_id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.int_gateway.id
}





resource "aws_eip" "elastic_ip_gateway" {
  vpc        = true
  depends_on = [aws_internet_gateway.int_gateway]
}

resource "aws_nat_gateway" "gateway" {
  subnet_id     = aws_subnet.public_sub_1.id
  allocation_id = aws_eip.elastic_ip_gateway.id
}

resource "aws_route_table" "private-rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.gateway.id
  }
}

resource "aws_route_table_association" "public-rt" {
  subnet_id      = aws_subnet.public_sub_1.id
  route_table_id = aws_vpc.vpc.main_route_table_id
}

resource "aws_route_table_association" "private_sub1" {
  subnet_id      = aws_subnet.private_sub_1.id
  route_table_id = aws_route_table.private-rt.id
}

resource "aws_route_table_association" "private_sub2" {
  subnet_id      = aws_subnet.private_sub_2.id
  route_table_id = aws_route_table.private-rt.id
}
