# Variables defined for VPC Module and CIDR block

variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR block for vpc"
}

# Defined VPC Name

variable "vpc_name" {
  default     = "capstone-vpc"
  description = "capstone-vpc for STS"
}


# Variables defined for 3 avaliabity zones. 
# using the {} to pass in unknown values that come from main.tf

variable "public_avaliblity_zone_1" {}
variable "private_avaliblity_zone_1" {}
variable "private_avaliblity_zone_2" {}

# Variables defined for 3 cidr blocks. 
# using the {} to pass in unknown values that come from main.tf

variable "public_cidr_block" {}
variable "private_cidr_block_1" {}
variable "private_cidr_block_2" {}
