variable "vpc_cidr" {
  description = "CIDR for the MWAA VPC. Avoid 10.0.0.0/16 if tf-main-vpc still exists."
  type        = string
  default     = "10.2.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDRs — host the NAT Gateway"
  type        = list(string)
  default     = ["10.2.1.0/24", "10.2.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "Private subnet CIDRs — host MWAA itself"
  type        = list(string)
  default     = ["10.2.3.0/24", "10.2.4.0/24"]
}

variable "availability_zones" {
  description = "AZs, aligned by index with the subnet CIDR lists"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "airflow_version" {
  description = "MWAA Airflow version. 2.5.1 is end-of-support and will be rejected."
  type        = string
  default     = "2.11.2"
}

variable "environment_class" {
  description = "MWAA environment size"
  type        = string
  default     = "mw1.small"
}

variable "environment_name" {
  description = "Name of the MWAA environment"
  type        = string
  default     = "tf-airflow-environment"
}