provider "aws" {
  region = "us-east-2"
}

terraform {
  backend "s3" {
    key = "staging/services/web/terraform.tfstate"
  }
}

resource "aws_instance" "pumpFactory" {
  ami = "ami-085f9c64a9b75eed5"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  # user_data = <<-EOF
  #       #!/bin/bash
  #       echo "<html><h1>pumpFactory</h1></html>" > index.html
  #       echo ${data.terraform_remote_state.postgresql.outputs.address} >> index.html
  #       echo ${data.terraform_remote_state.postgresql.outputs.port} >> index.html
  #       nohup busybox httpd -f -p ${var.server_port} &
  #       EOF

  #IMPORTANT: postgresql must be json encoded! 
    user_data = templatefile("user-data.sh", {
    server_port      = var.server_port
    postgresql_address = jsonencode(data.terraform_remote_state.postgresql.outputs.address.address)
    postgresql_port    = data.terraform_remote_state.postgresql.outputs.port
  })

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

data "terraform_remote_state" "postgresql" {
    backend = "s3"

    config = {
        bucket = "pumpfactory-tf-s3-bucket"
        key = "staging/data-stores/postgresql/terraform.tfstate"
        region = "us-east-2"
    }
}