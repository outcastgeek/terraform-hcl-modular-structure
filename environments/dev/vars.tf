
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

variable "backend_url_env_name" {
  type        = string
  description = "The Backend Environment Variable URL"
  default     = "NONE"
}

variable "backend_url_path" {
  type        = string
  description = "The Backend URL Path"
  default     = ""
}

variable "backend_urls" {
  type        = map(string)
  description = "API URLs"
  default = {
    "asia"         = "http://no-backend.url"
    "europe"       = "http://no-backend.url"
    "southamerica" = "http://no-backend.url"
    "northamerica" = "http://no-backend.url"
  }
}

variable "ports_name" {
  type        = string
  description = "The Backend URL Path"
  default     = "http1" // h2c
}

variable "here_index_name" {
  type        = string
  description = "Here Index Name"
  default = "adjmmrkt_here"
}

variable "esri_index_name" {
  type        = string
  description = "Esri Index Name"
  default = "adjmmrkt_esri"
}


variable "here_index_use" {
  type        = string
  description = "Here Index Intended Use"
  default = "Storage"
}

variable "esri_index_use" {
  type        = string
  description = "Esri Index Intended Use"
  default = "Storage"
}
