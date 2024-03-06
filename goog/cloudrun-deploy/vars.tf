
variable "project_id" {
  type        = string
  description = "The Google Project ID"
}

variable "service_name" {
  type        = string
  description = "The Service Name"
}

variable "docker_image" {
  type        = string
  description = "The Docker Image"
}

variable "env_vars" {
  type = map(object({
    EnvName  = string # Env Variable Name
    EnvValue = string # Env Variable Value
  }))
  description = "Environment Variables"
}

variable "aws_goog_regions" {
  type = map(object({
    aws_region  = string # AWS Region
    goog_region = string # Google Region
  }))
  description = "AWS Google Region Mapping"
  default = {
    "asia" = {
      aws_region  = "ap-northeast-1"
      goog_region = "asia-northeast1"
    },
    "europe" = {
      aws_region  = "eu-west-2"
      goog_region = "europe-west1"
    },
    # "southamerica" = {
    #   aws_region  = "sa-east-1"
    #   goog_region = "southamerica-east1"
    # },
    "northamerica" = {
      aws_region  = "us-east-1"
      goog_region = "us-central1"
    },
  }
}

variable "gcloud_locations" {
  #type = list(string)
  type        = set(string)
  description = "The Google Project Service Locations"
  default     = ["asia-northeast1", "europe-west1", "southamerica-east1", "us-central1"]
}

variable "aws_locations" {
  #type = list(string)
  type        = set(string)
  description = "The AWS Locations"
  default     = ["ap-northeast-1", "eu-west-2", "us-east-1"]
  # default     = ["ap-northeast-1", "eu-west-2", "sa-east-1", "us-east-1"]
}

variable "knative_maxscale" {
  type        = string
  description = "The Google Cloud Run Service Autoscaling Knative Max Scale"
  default     = "1"
}

variable "environment" {
  type        = string
  description = "Environment"
}

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

variable "account_hosts" {
  type        = map(string)
  description = "Account Hosts"
  default = {
    "asia"         = "http://no-backend.url"
    "europe"       = "http://no-backend.url"
    "southamerica" = "http://no-backend.url"
    "northamerica" = "http://no-backend.url"
  }
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
