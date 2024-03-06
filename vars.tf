
variable "aws_access_key_id" {
  type        = string
  description = "AWS_ACCESS_KEY_ID"
  default     = "no-aws_access_key_id"
}

variable "aws_secret_access_key" {
  type        = string
  description = "AWS_SECRET_ACCESS_KEY"
  default     = "no-aws_secret_access_key"
}

variable "algolia_application_id" {
  type        = string
  description = "ALGOLIA_APPLICATION_ID"
  default     = "no-algolia_application_id"
}

variable "algolia_api_key" {
  type        = string
  description = "ALGOLIA_API_KEY"
  default     = "no-algolia_api_key"
}
