variable "my_ip" {
  description = "Public IP in CIDR notation, followed by /32"
  type        = string

  validation {
    condition     = can(cidrhost(var.my_ip, 0))
    error_message = "my_ip must be valid CIDR notation, including /32 suffix."
  }
}

variable "vpc_name" {
  description = "Name tag of the VPC created in Assignment 1"
  type        = string
  default     = "tf-main-vpc"
}

variable "peer_vpc_cidr_for_icmp" {
  description = "Peer VPC CIDR permitted to send/receive ICMP"
  type        = string
  default     = "10.1.0.0/16"
}