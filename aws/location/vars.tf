variable "here_index_name" {
  type        = string
  description = "Here Index Name"
  default = "mywebapp_here"
}

variable "esri_index_name" {
  type        = string
  description = "Esri Index Name"
  default = "mywebapp_esri"
}


variable "here_index_use" {
  type        = string
  description = "Here Index Intended Use"
  default = "SingleUse"
}

variable "esri_index_use" {
  type        = string
  description = "Esri Index Intended Use"
  default = "SingleUse"
}
