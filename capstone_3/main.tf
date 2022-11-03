provider "aws" {
    profile                 = "default"
    region                  = "us-east-1"
}

module "vpc" {
  source = "/Users/tres/Documents/STS/IaC Bootcamp/terraform/capstone_3/modules/vpc"
  vpc_name = "capstone-vpc"
  vpc_cidr = "172.152.0.0/16"
  public_cidr_block = "172.152.1.0/24"
  private_cidr_block_1 = "172.152.2.0/24"
  private_cidr_block_2 = "172.152.3.0/24"
  public_avaliblity_zone_1= data.aws_availability_zones.available.names[0]
  private_avaliblity_zone_1 = data.aws_availability_zones.available.names[1]
  private_avaliblity_zone_2= data.aws_availability_zones.available.names[0]
}

# data source to query az's that are in available state

data "aws_availability_zones" "available" {
  state = "available"
}

#### RDS Setup Configuration#####


resource "aws_db_subnet_group" "rds-subnet" {
  name       = "db-subnet-group"
  subnet_ids = [module.vpc.private_sub_1 , module.vpc.private_sub_2]

  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_security_group" "rds-security-group" {
  name        = "rds-security-group"
  description = "allow inbound access to the database"
  vpc_id      = module.vpc.vpc_id

  ingress {
    // protocol    = "tcp"
    // from_port   = 0
    // to_port     = 3306
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [ "0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

##### RDS Instance Setup ####

resource "aws_db_instance" "rds-db" {
  allocated_storage    = 150
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = "db.t2.micro"
  identifier           = "rdscapstone"
  db_name              = "drupaldb"
  username             = "drupal"
  password             = "demouser"
  skip_final_snapshot  = true
  db_subnet_group_name = aws_db_subnet_group.rds-subnet.id
  vpc_security_group_ids = [ aws_security_group.rds-security-group.id ]
}

output "rds_endpoint" {
  value = "${aws_db_instance.rds-db.endpoint}"
}



resource "aws_instance" "webserver" {
    ami           = "ami-002070d43b0a4f171"
    instance_type = "t2.large"
    subnet_id     = module.vpc.subnet_public_id
    key_name      = "STS-Keypair-001"
    vpc_security_group_ids = [ aws_security_group.ec2-security-group.id ]
    associate_public_ip_address = true
    user_data = "${file("user-data-script.sh")}"

    tags = {
        Name = "capstone-ec2"
    }

    depends_on = [ module.vpc.vpc_id, module.vpc.int_gateway_id ]

}

data "template_file" "user-data" {
  template = file("mysql.sh")
  vars = {
     rds = aws_db_instance.rds-db.endpoint
  }
}



resource "aws_security_group" "ec2-security-group" {
  name        = "security-group"
  description = "allow inbound access to the EC2 instance"
  vpc_id      = module.vpc.vpc_id

  ingress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

