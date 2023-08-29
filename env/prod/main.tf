module "aws-prod" {
  source              = "../../infra"
  instance_type       = "t2.micro"  # para producao eu posso trocar mais tarde a maquina
  aws_region          = "us-east-1" # posso trocar tambem a regiao mas nao tem necessidade para aprendizagem
  key                 = "aws-key-prod"
  ec2_name            = "prod"
  security_group_name = "PROD"
  max_ec2             = 10
  min_ec2             = 1
  group_name          = "PROD"
  production = true
}