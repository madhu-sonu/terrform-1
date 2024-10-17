terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}
resource "aws_instance" "new" {
  ami           = "ami-0866a3c8686eaeeba"
  instance_type = var.aws_instance
  #vpc_security_group_ids = [var.vpc_security_group_id]
  key_name               = aws_key_pair.key-2.key_name
  vpc_security_group_ids = [aws_security_group.main.id]
  user_data = data.template_file.user_data.rendered
  tags = {
    Name = "M1"
  }

}
data "template_file" "user_data"{
  template = file("./installation.sh")
}

resource "aws_key_pair" "key-2" {
  key_name   = var.key_name
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCr57bCiVUVcfJ1rGuYSAUivfeyvMBfRSXiOmGtPn5/p8L+AsqUINUELhsfeG+mTlhL6Zqfil8AyIma1Pi/jUJAmkpSDbzFmuHd8EnVwiD+2bdPHUmo8xJphTK16JzgmpqPn8nsLBx6KZQsy9pYQbA2HSZ51PhtrTVyFBjuDrp72Cm3A1Au9iA+8xk0nZoG57+wwmT/lalcP2jWp5uxZrv3ExZUBhrmZGg90jcAIe3tBxOyJxuDAZ+NAOm0KSl4dPBeWGpj6mhxr3ZVca+i5Rdmo5/dj3xcaDBLbSeUPzOztv7ybHUcdcF66uPviRuHcBmC1/5qrNiOPXKg936bSWc5 DELL@DESKTOP-L6IM9AN"
}


resource "aws_security_group" "main" {
  egress = [
    {
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = ""
      from_port        = 0
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "-1"
      security_groups  = []
      self             = false
      to_port          = 0
    }
  ]
  ingress = [
      for port in [22,8080,443,80] :{
      cidr_blocks      = ["0.0.0.0/0", ]
      description      = "inbound reules"
      from_port        = port
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      protocol         = "tcp"
      security_groups  = []
      self             = false
      to_port          = port
    }
  ]
}
