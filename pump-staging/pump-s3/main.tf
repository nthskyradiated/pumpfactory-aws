provider "aws" {
    region = "us-east-2"
}

resource "aws_s3_bucket" "pumpfactory-tf-s3-bucket" {
  bucket = "pumpfactory-tf-s3-bucket"

  tags = {
    Name        = "PumpS3 bucket"
    Environment = "Dev"
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_s3_bucket_versioning" "pumpfactory-tf-s3-bucket-versioning" {
  bucket = aws_s3_bucket.pumpfactory-tf-s3-bucket.id
  versioning_configuration {
    status = "Enabled"
  }
  
}

resource "aws_s3_bucket_server_side_encryption_configuration" "pumpfactory-tf-s3-bucket-encryption" {
  bucket = aws_s3_bucket.pumpfactory-tf-s3-bucket.id
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "pumpfactory-tf-s3-public-access" {
  bucket = aws_s3_bucket.pumpfactory-tf-s3-bucket.id
  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true
  
}

resource "aws_dynamodb_table" "pumpfactory-tf-Dynamodb-table" {
  name = "pumpfactory-tf-Dynamodb-table"
  billing_mode = "PAY_PER_REQUEST"
  hash_key = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
  
}

terraform {
  backend "s3" {
    bucket = "pumpfactory-tf-s3-bucket"
    key = "global/s3/pumpfactory.tfstate"
    region = "us-east-2"
    dynamodb_table = "pumpfactory-tf-Dynamodb-table"
    encrypt = true
  }
}

resource "aws_instance" "pf-bastion" {
  ami = "ami-085f9c64a9b75eed5"
  instance_type = "t2.micro"
  vpc_security_group_ids = ["sg-017a96a7c4b7a36cf"]
  tags = {
    Name = "pf-bastion"
  }
  
}