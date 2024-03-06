terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20.1"
    }
  }
}

resource "aws_location_place_index" "adjmmrkt_here" {
    data_source = "Here"
    index_name = var.here_index_name
    data_source_configuration {
        intended_use = var.here_index_use
    }
}

resource "aws_location_place_index" "adjmmrkt_esri" {
    data_source = "Esri"
    index_name = var.esri_index_name
    data_source_configuration {
        intended_use = var.esri_index_use
    }
}

output "adjmmrkt_here_index" {
  value = aws_location_place_index.adjmmrkt_here.id
}

output "adjmmrkt_esri_index" {
  value = aws_location_place_index.adjmmrkt_esri.id
}
