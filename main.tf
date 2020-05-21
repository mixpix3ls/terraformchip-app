provider "aws" {
  region = "us-west-1"
}

data "aws_availability_zones" "azs-app" {
  state = "available"
}

module "vpc-app" {
  source = "terraform-aws-modules/vpc/aws"
  name = "vpc-app"
  cidr = "192.169.0.0/16"
  azs             = [data.aws_availability_zones.azs-app.names[0], data.aws_availability_zones.azs-app.names[1]]
  private_subnets  = ["192.169.1.0/24", "192.169.2.0/24"]
}