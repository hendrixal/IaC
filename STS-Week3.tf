provider "aws" {
    region     = "us-east-1"
    profile = "default"
}

resource "aws_instance" "apache_ec2" {
    ami = "ami-002070d43b0a4f171"
    instance_type = "t2.micro"
    key_name = "STS-Keypair-001"
    security_groups = ["security_group-001"]
    tags = {
    Name = "STS-Week-3"
  }

  user_data = <<-EOF
#!/bin/bash
sudo yum -y updatepw
echo "*** Installing apache"
sudo yum -y install httpd
sudo service httpd start
export NAME=Andrew
export CLOUD=AWS
sudo touch /var/www/html/index.html
sudo chown centos /var/www/html/index.html
sudo chmod 755 /var/www/html/index.html
sudo echo "Hello world, my name is "$NAME" my favorite cloud provider is "$CLOUD" and my virtual machine's hostname is "$HOSTNAME > /var/www/html/index.html
EOF

}


