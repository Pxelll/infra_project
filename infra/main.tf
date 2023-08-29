terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.27"
    }
  }

  required_version = ">= 0.14.9"
}

provider "aws" {
  profile = "default"
  region  = var.aws_region
}

resource "aws_launch_template" "EC2_template" {
  image_id      = var.ubuntu_22_04_lts
  instance_type = var.instance_type
  key_name      = var.key
    tags = {
      Name = "${var.ec2_name}_"
    }
  security_group_names = [ var.security_group_name ]
  user_data = var.production ? ("ansible.sh") : "" #":" eh como se fosse um else
}

#resource "aws_instance" "EC2_MACHINE" {
#  launch_template {
#    id = aws_launch_template.EC2_template.id
#    version = "$Latest"
#  }
#}

resource "aws_key_pair" "aws_key_pub" {
  key_name   = var.key
  public_key = file("${var.key}.pub")

}

resource "aws_autoscaling_group" "group" {
  name = var.group_name
  max_size = var.max_ec2
  min_size = var.min_ec2
  availability_zones = ["${var.aws_region}a", "${var.aws_region}b"]
  launch_template {
    id = aws_launch_template.EC2_template.id
    version = "$Latest"
  }
  target_group_arns = var.production ? [ aws_lb_target_group.Target_LoadBalancer[0].arn ] : []
}

resource "aws_default_subnet" "subnet_01" {
  availability_zone = "${var.aws_region}a"
}

resource "aws_default_subnet" "subnet_02" {
  availability_zone = "${var.aws_region}b"
}

resource "aws_lb" "LoadBalancer" {
  internal = false
  subnets = [ aws_default_subnet.subnet_01.id, aws_default_subnet.subnet_02.id ]
  security_groups = [ aws_security_group.Sentinel_Fortress.id ]
  count = var.production  ? 1 : 0
}

resource "aws_default_vpc" "default" { # usando a vpc padrao da aws (para criar uma propria eh mais complicado), essa sessao eh apenas para poder colocar a vpc no aws_lb_target_group
  
}

resource "aws_lb_target_group" "Target_LoadBalancer" {
  name = "targetInstances"
  port = "8000"
  protocol = "HTTP" # porque a nossa aplicacao funciona via HTTP
  vpc_id = aws_default_vpc.default.id
  count = var.production  ? 1 : 0
}
resource "aws_lb_listener" "LoadBalancer_entrance" {
  load_balancer_arn = aws_lb.LoadBalancer[0].arn
  port = "8000"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.Target_LoadBalancer[0].arn
  }
  count = var.production  ? 1 : 0
}

resource "aws_autoscaling_policy" "prod_scalation" {
  name = "terraform_scale"
  autoscaling_group_name = var.group_name
  policy_type = "TargetTrackingScaling" # numero de requisicoes ou consumo de cpu
  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = 20.0
  }
  count = var.production  ? 1 : 0
}