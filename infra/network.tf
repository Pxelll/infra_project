resource "aws_security_group" "Sentinel_Fortress" {
  name = "Sentinel Fortress"
  description = "Security group for DEV environment"
  ingress{ #pode ouvir outras redes ao redor do mundo
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  egress{ #responde requisicoes que chegam no servidor
    cidr_blocks = [ "0.0.0.0/0" ]
    ipv6_cidr_blocks = [ "::/0" ]
    from_port = 0
    to_port = 0
    protocol = "-1"
  }
  
  tags = {
    Name = "Sentinel_Fortress"
    environment = "Dev"
  }
}