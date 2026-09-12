variable "subnet_name" {
  description = "Name tag of the subnet to launch into. Subnet 2 is on the default NACL, which permits UDP/DNS."
  type        = string
  default     = "tf-public-subnet-2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "key_name" {
  description = "Name for the EC2 key pair"
  type        = string
  default     = "tf-lab-key"
}

variable "public_key_path" {
  description = "Path to your SSH public key"
  type        = string
  default     = "~/.ssh/tf-lab-key.pub"
}