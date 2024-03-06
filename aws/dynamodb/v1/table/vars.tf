
variable "table_name" {
  type        = string
  description = "Dynamodb Table Name"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "timeouts" {
  description = "Updated Terraform resource management timeouts"
  type        = map(string)
  default = {
    create = "10m"
    update = "60m"
    delete = "10m"
  }
}
