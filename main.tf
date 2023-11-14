provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "frontend" {
  ami           = "ami-05c13eab67c5d8861"
  instance_type = "t2.micro"
  key_name      = "linux"
  vpc_security_group_ids = ["sg-04cb5f715d70d6f35"]
  tags = {
    Name = "u21.local"
  }
}

resource "aws_instance" "backend" {
  ami           = "ami-0fc5d935ebf8bc3bc"
  instance_type = "t2.micro"
  key_name      = "ubuntu-key"
  vpc_security_group_ids = ["sg-04cb5f715d70d6f35"]
  tags = {
    Name = "c8.local"
  }
}


output "frontend_public_ip" {
  value = aws_instance.frontend.public_ip
}

output "backend_public_ip" {
  value = aws_instance.backend.public_ip
}


module "ansible_inv" {
  source  = "mschuchard/ansible-inv/local"
  version = "~> 1.1.2"

  formats   = ["yaml"]
  instances = {
    "frontend" = [
      {
        name = aws_instance.frontend.public_dns
        ip   = aws_instance.frontend.public_ip
        vars = aws_instance.frontend.tags
      }
    ],
    "backend" = [
      {
        name = aws_instance.backend.private_dns
        ip   = aws_instance.backend.public_ip
        vars = aws_instance.backend.tags
      }
    ]
  }
  group_vars = {
    "frontend" = { "interface" = "public" }
    "backend"  = { "interface" = "private" }
  }
}