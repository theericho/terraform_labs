variable "peer_vpc_cidr" {
  description = "CIDR for the second VPC. Must not overlap the main VPC."
  type        = string
  default     = "10.1.0.0/16"
}

variable "peer_subnet_cidr" {
  description = "CIDR for the subnet in the peer VPC"
  type        = string
  default     = "10.1.1.0/24"
}

variable "peer_az" {
  description = "AZ for the peer subnet. Matching the main instance's AZ keeps peering traffic free."
  type        = string
  default     = "us-east-1a"
}

variable "my_ip" {
  description = "Your public IP in CIDR notation, for SSH access to the test instances"
  type        = string

  validation {
    condition     = can(cidrhost(var.my_ip, 0))
    error_message = "my_ip must be valid CIDR notation, including the /32 suffix."
  }
}