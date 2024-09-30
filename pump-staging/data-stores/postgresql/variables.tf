variable "username" {
    description = "value of the username for the database"
    type = string
    sensitive = true
}

variable "password" {
  description = "value of the password for the database"
  type = string
  sensitive = true
}