variable "cluster_name" {
  description = "cluster name"
  default     = "ecs-cluster"

}

variable "ingress_rules" {
  type = map(object({
    port = number
  }))
  default = {
    "http" = {
      port = 80
    },
    "https" = {
      port = 443
    }
  }
  }