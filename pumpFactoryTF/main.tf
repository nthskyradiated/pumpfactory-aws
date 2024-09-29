provider "aws" {
  region = "us-east-1"
}
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "5.69.0"
    }
  }
}


resource "aws_instance" "pumpFactory" {
  ami = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
        #!/bin/bash
        echo "<html><h1>Hello World</h1></html>" > index.html
        nohup busybox httpd -f -p 8080 &
        EOF

user_data_replace_on_change = true

  tags = {
    Name = "pumpFactory"
  }
}

resource "aws_security_group" "instance" {
    name = "web"

    ingress {
        from_port = var.server_port
        to_port = var.server_port
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
  
}