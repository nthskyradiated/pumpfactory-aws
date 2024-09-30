provider "aws" {
    region = "us-east-2"
}

terraform {
  backend "s3" {
    key = "staging/data-stores/postgresql/terraform.tfstate"
  }
}

resource "aws_db_instance" "staging-pumpdb" {
    identifier_prefix = "staging-pumpdb"
    engine = "postgres"
    engine_version = "15"
    instance_class = "db.t3.micro"
    allocated_storage = 10
    skip_final_snapshot = true
    publicly_accessible = true
    
    db_name = "pumpdb"
    username = var.username
    password = var.password
}