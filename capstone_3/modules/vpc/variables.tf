variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "cidr for vpc"
}

variable "vpc_name" {
  default     = "capstone-vpc"
  description = ""
}

variable "public_avaliblity_zone_1" {}
variable "private_avaliblity_zone_1" {}
variable "private_avaliblity_zone_2" {}


variable "public_cidr_block" {}
variable "private_cidr_block_1" {}
variable "private_cidr_block_2" {}
