variable "aws_region" {
  description = "AWS region for TaskFlow infrastructure"
  type        = string
  default     = "eu-north-1"
}
variable "db_password" {
  description = "Password for the TaskFlow PostgreSQL database"
  type        = string
  sensitive   = true
}
