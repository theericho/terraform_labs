variable "private_subnet_cidrs" {
  description = "CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.101.0/24", "10.0.102.0/24"]
}

variable "availability_zones" {
  description = "AZs for the private subnets; must align by index with private_subnet_cidrs"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "db_username" {
  description = "Master username for the RDS instance"
  type        = string
  default     = "adminuser"
}

variable "db_password" {
  description = "Master password for the RDS instance"
  type        = string
  sensitive   = true

  validation {
    condition     = length(var.db_password) >= 8
    error_message = "Password must be at least 8 characters."
  }

  validation {
    condition     = !can(regex("[/@\"' ]", var.db_password))
    error_message = "MySQL master passwords cannot contain / @ \" ' or spaces."
  }
}

variable "db_name" {
  description = "Name of the initial database"
  type        = string
  default     = "myappdb"
}