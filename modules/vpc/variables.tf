variable "environment" {
  description = "Env variable"
  type        = string
  default     = "Test"
}

variable "vpc_name" {
  description = "VPC name"
  type        = string
  default     = "Main-VPC"
}

variable "cidr_block" {
  description = "Cidr block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "availability_zones" {
  description = "AZs"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "public_subnets" {
  description = "Public Subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnets" {
  description = "Private Subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]

}
