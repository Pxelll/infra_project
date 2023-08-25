module "aws-prod" {
  source = "../../infra"
  instance_type = "t2.micro" # para producao eu posso trocar mais tarde a maquina
  aws_region = "us-east-1" # posso trocar tambem a regiao mas nao tem necessidade para aprendizagem
  key = "aws-key-prod"
  ec2_name = "ec2_prod"
}

output "public_ip_prod" {
  value = module.aws-prod.public_ip
}