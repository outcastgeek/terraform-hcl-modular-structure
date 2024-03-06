

variable "table_name" {
  type        = string
  description = "Dynamodb Table Name"
}

variable "environment" {
  type        = string
  description = "Environment"
}

variable "region_names" {
  #type = list(string)
  type        = set(string)
  description = "The AWS Region Names"
  default     = ["ap-northeast-1", "eu-west-2", "us-east-1"]
  # default     = ["ap-northeast-1", "eu-west-2", "sa-east-1", "us-east-1"]
}
