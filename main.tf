provider "aws" {
  region = "us-west-1"
}

provider "aws" {
  region = "eu-central-1"
  alias  = "eu"
}

data "aws_availability_zones" "azs" {
  state = "available"
}

data "aws_availability_zones" "azs-eu" {
  provider = aws.eu
  state    = "available"
}

module "vpc-app" {
  source          = "terraform-aws-modules/vpc/aws"
  name            = "vpc-app"
  cidr            = "192.169.0.0/16"
  azs             = [data.aws_availability_zones.azs.names[0], data.aws_availability_zones.azs.names[1]]
  private_subnets = ["192.169.1.0/24", "192.169.2.0/24"]
}

module "vpc-admin" {
  source          = "terraform-aws-modules/vpc/aws"
  name            = "vpc-admin"
  cidr            = "192.170.0.0/16"
  azs             = [data.aws_availability_zones.azs.names[0], data.aws_availability_zones.azs.names[1]]
  private_subnets = ["192.170.1.0/24", "192.170.2.0/24"]
}

module "vpc-app-eu" {
  providers = {
    aws = aws.eu
  }
  source          = "terraform-aws-modules/vpc/aws"
  name            = "vpc-app-eu"
  cidr            = "192.172.0.0/16"
  azs             = [data.aws_availability_zones.azs-eu.names[0], data.aws_availability_zones.azs-eu.names[1]]
  private_subnets = ["192.172.1.0/24", "192.172.2.0/24"]
}

# Create a bastion host in one of the vpc-admin subnets
# TODO VPC peering stuff
resource "aws_instance" "bastion" {
  ami                         = "ami-969ab1f6"
  instance_type               = "t2.micro"
  associate_public_ip_address = true
  # subnet_id = module.vpc-admin.private_subnets[0]
  subnet_id         = "subnet-0325f8c9f62fec88d"
  availability_zone = "us-west-1b"


}

####################
# Drupal Application TODOS

# Create an EC2 instance that has Drupal installed on it - done
# Ideally, put the instance in an AutoScaling Group - not done
# Create an RDS instance (MySQL or Postgres)
# Create a security group to allow the EC2 instance or ASG to connect to the RDS instance
#####################

# Launch a Bitnami Drupal AMI in one of the vpc-app subnets
resource "aws_instance" "appvm" {
  ami           = "ami-0276cbf32e041c21b"
  instance_type = "t2.micro"
  # subnet_id     = module.vpc-app.private_subnets[0]
  subnet_id         = "subnet-01d0db40eb76252ec"
  availability_zone = "us-west-1b"
  # to test Sentinel Policy for AZ restriction
  # subnet_id = "subnet-06338bbb2e57a8da3"
  # availability_zone = "eu-central-1b"
}

# Create an RDS instance
# resource "aws_db_instance" "default" {
#   allocated_storage    = 20
#   storage_type         = "gp2"
#   engine               = "mysql"
#   engine_version       = "5.7"
#   instance_class       = "db.t2.micro"
#   name                 = "mydb"
#   username             = var.rds_user
#   password             = var.rds_pass
#   parameter_group_name = "default.mysql5.7"
# }

