variable "kafka_version" {
  description = "MSK Kafka version. Append .kraft for KRaft mode (disables the ZooKeeper output)."
  type        = string
  default     = "3.9.x"
}

variable "broker_instance_type" {
  description = "MSK broker instance type"
  type        = string
  default     = "kafka.t3.small"
}

variable "number_of_broker_nodes" {
  description = "Total brokers. Must be a multiple of the number of client_subnets."
  type        = number
  default     = 2
}

variable "broker_volume_size" {
  description = "EBS volume size per broker, GiB"
  type        = number
  default     = 10
}

variable "my_ip" {
  description = "Your public IP in CIDR notation, for SSH to the client instance"
  type        = string

  validation {
    condition     = can(cidrhost(var.my_ip, 0))
    error_message = "my_ip must be valid CIDR notation, including the /32 suffix."
  }
}