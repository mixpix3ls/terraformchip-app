provider "aws" {
  region = "us-west-1"
}

data "aws_availability_zones" "azs-app" {
  state = "available"
}

module "vpc-app" {
  source          = "terraform-aws-modules/vpc/aws"
  name            = "vpc-app"
  cidr            = "192.169.0.0/16"
  azs             = [data.aws_availability_zones.azs-app.names[0], data.aws_availability_zones.azs-app.names[1]]
  private_subnets = ["192.169.1.0/24", "192.169.2.0/24"]
}

module "vpc-admin" {
  source          = "terraform-aws-modules/vpc/aws"
  name            = "vpc-admin"
  cidr            = "192.170.0.0/16"
  azs             = [data.aws_availability_zones.azs-app.names[0], data.aws_availability_zones.azs-app.names[1]]
  private_subnets = ["192.170.1.0/24", "192.170.2.0/24"]
}

# Create a bastion host in one of the vpc-admin subnets
# TODO VPC peering stuff
resource "aws_instance" "bastion" {
  ami = "ami-969ab1f6"
  instance_type = "t2.micro"
  associate_public_ip_address = true
  subnet_id = module.vpc-admin.aws_subnet.private[0].id
}

# Drupal Application TODOS
# Create an EC2 instance that has Drupal installed on it
# Ideally, put the instance in an AutoScaling Group
# Create an RDS instance (MySQL or Postgres)
# Create a security group to allow the EC2 instance or ASG to connect to the RDS instance

# Launch a Bitnami Drupal AMI in one of the vpc-app subnets
resource "aws_instance" "appvm" {
  ami           = "ami-0276cbf32e041c21b"
  instance_type = "t3a.small"
  subnet_id     = module.vpc-app.aws_subnet.private[0].id
}