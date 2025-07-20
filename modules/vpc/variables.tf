variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block for the VPC"
}

variable "public_ip" {
  type        = bool
  description = "add public ip"
  default     = true
}