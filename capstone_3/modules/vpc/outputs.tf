# Create output values to associate resource id's on creation to configrue aws resources
# The below output values will be used in main.terraform


output "vpc_id" {
    value = aws_vpc.vpc.id
}


output "vpc_cidr" {
    value = aws_vpc.vpc
}

output "int_gateway_id" {
    value = aws_internet_gateway.int_gateway.id
}

output "subnet_public_id" {
    value = aws_subnet.public_sub_1.id
}

output "private_sub_1" {
    value = aws_subnet.private_sub_1.id
}


output "private_sub_2" {
    value = aws_subnet.private_sub_2.id
}

output "private_rt_id" {
    value = aws_route_table.private-rt.id
}
