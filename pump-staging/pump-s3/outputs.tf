output "aws_s3_bucket_arn" {
    value = aws_s3_bucket.pumpfactory-tf-s3-bucket.arn
    description = "The ARN of the S3 bucket"
    sensitive = false
  
}

output "aws_dynamodb_table_name" {
    value = aws_dynamodb_table.pumpfactory-tf-Dynamodb-table.name
    description = "The name of the DynamoDB table"
    sensitive = false
  
}