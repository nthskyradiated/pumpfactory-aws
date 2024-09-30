output "address" {
  value = aws_db_instance.staging-pumpdb
  description = "The address of the RDS instance"
  sensitive = true
}

output "port" {
  value = aws_db_instance.staging-pumpdb.port
  description = "RDS instance port number"
  sensitive = true
}