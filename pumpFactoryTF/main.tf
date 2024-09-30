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

# data "aws_vpc" "default" {
#   default = true
# }

# data "aws_subnets" "default" {
#   filter {
#     name = "vpc-id"
#     values = [data.aws_vpc.default.id]
#   }
# }


# resource "aws_launch_configuration" "pumpFactory" {
#     image_id = "ami-0e86e20dae9224db8"
#     instance_type = "t2.micro"
#     security_groups = [aws_security_group.instance.id]
#     user_data = <<-EOF
#         #!/bin/bash
#         echo "<html><h1>pumpFactory</h1></html>" > index.html
#         nohup busybox httpd -f -p ${var.server_port} &
#         EOF

#     lifecycle {
#         create_before_destroy = true
#     }

    
# }
resource "aws_instance" "pumpFactory" {
  ami = "ami-0e86e20dae9224db8"
  instance_type = "t2.micro"
  vpc_security_group_ids = [aws_security_group.instance.id]

  user_data = <<-EOF
        #!/bin/bash
        echo "<html><h1>pumpFactory</h1></html>" > index.html
        nohup busybox httpd -f -p ${var.server_port} &
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

# resource "aws_autoscaling_group" "pumpFactory" {
#     launch_configuration = aws_launch_configuration.pumpFactory.name
#     vpc_zone_identifier = data.aws_subnets.default.ids
#     target_group_arns = [aws_lb_target_group.PF_TargetGroup.arn]
#     health_check_type = "ELB"
#     min_size = 2
#     max_size = 10

#     tag {
#         key = "Name"
#         value = "pumpFactory"
#         propagate_at_launch = true
#     }
  
# }

# resource "aws_lb" "PF_LB" {
#     name = "pumpFactory"
#     load_balancer_type = "application"
#     subnets = data.aws_subnets.default.ids
#     security_groups = [aws_security_group.PF_SecurityGroup.id]
# }

# resource "aws_lb_listener" "PF_LB_Listener" {
#     load_balancer_arn = aws_lb.PF_LB.arn
#     port = 80
#     protocol = "HTTP"

#     default_action {
#         type = "fixed-response"

#         fixed_response {
#             content_type = "text/plain"
#             message_body = "404: page not found"
#             status_code = 404
#         }
#     }
  
# }

# resource "aws_security_group" "PF_SecurityGroup" {
#     name = "pumpFactory_security_group"

#     ingress {
#         from_port = 443
#         to_port = 443
#         protocol = "tcp"
#         cidr_blocks = ["0.0.0.0/0"]
#     }

#     egress {  
#         from_port = 0
#         to_port = 0
#         protocol = "-1"
#         cidr_blocks = ["0.0.0.0/0"]
#     }
  
# }

# resource "aws_lb_target_group" "PF_TargetGroup" {
#     name = "pumpFactory-target-group"
#     port = var.server_port
#     protocol = "HTTP"
#     vpc_id = data.aws_vpc.default.id

#     health_check {
#         path = "/"
#         protocol = "HTTP"
#         matcher = "200"
#         interval = 15
#         timeout = 3
#         healthy_threshold = 2
#         unhealthy_threshold = 2
#     }
  
# }

# resource "aws_lb_listener_rule" "PF_LB_Listener_Rule" {
#     listener_arn = aws_lb_listener.PF_LB_Listener.arn
#     priority = 100

#     condition {
#         path_pattern {
#             values = ["*"]  
#         }
#     }

#     action {
#         type = "forward"
#         target_group_arn = aws_lb_target_group.PF_TargetGroup.arn
#     }
# }