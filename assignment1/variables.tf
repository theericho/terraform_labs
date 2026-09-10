variable "vpc_cidr" {
  description = "IP address range for the VPC, CIDR notation"
  type        = string
}

variable "public_subnet_cidrs" {
  description = "CIDR blocks for the public subnets, one per subnet"
  type        = list(string)
}

variable "availability_zones" {
  description = "AZ for the public subnets; must align by index with public_subnet_cidrs"
  type        = list(string)
}