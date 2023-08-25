module "aws-dev" {
  source = "../../infra"
  instance_type = "t2.micro"
  aws_region = "us-east-1"
  key = "aws-key-dev"
  ec2_name = "ec2_dev"
}

output "public_ip_dev" {
  value = module.aws-dev.public_ip
}