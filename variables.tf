variable "instance_type" {
    type = string
  
}

variable "instance_names" {
    type = list(string)
    default = ["webserver1", "webserver2"]
  
}