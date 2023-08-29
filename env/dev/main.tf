module "aws-dev" {
  source = "../../infra"
  instance_type = "t2.micro"
  aws_region = "us-east-1"
  key = "aws-key-dev"
  ec2_name = "ec2_dev"
  security_group_name = "DEV"
  group_name = "DEV"
  min_ec2 = 0
  max_ec2 = 1
  production = false
}