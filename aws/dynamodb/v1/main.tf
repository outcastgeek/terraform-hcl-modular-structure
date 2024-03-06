
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.20.0"
    }
  }
}
provider "aws" {
  alias  = "apnortheast"
  region = "ap-northeast-1"
}

provider "aws" {
  alias  = "euwest"
  region = "eu-west-2"
}

# provider "aws" {
#   alias  = "saeast"
#   region = "sa-east-1"
# }

provider "aws" {
  alias  = "useast"
  region = "us-east-1"
}

provider "aws" {
  # No Alias so this is the default
  region = "us-east-1"
}

module "ap-northeast-1" {
  providers = { 
    aws = aws.apnortheast
  }
  source      = "./table"
  table_name  = var.table_name
  environment = var.environment
}

module "eu-west-2" {
  providers = { 
    aws = aws.euwest
  }
  source      = "./table"
  table_name  = var.table_name
  environment = var.environment
}

# module "sa-east-1" {
#   providers = { 
#     aws = aws.saeast
#   }
#   source      = "./table"
#   table_name  = var.table_name
#   environment = var.environment
# }

module "us-east-1" {
  providers = { 
    aws = aws.useast
  }
  source      = "./table"
  table_name  = var.table_name
  environment = var.environment
}

resource "aws_dynamodb_global_table" "ddb_global_table" {
  # depends_on = [
  #   module.ap-northeast-1,
  #   module.eu-west-2,
  #   module.sa-east-1,
  #   module.us-east-1
  # ]

  depends_on = [
    module.ap-northeast-1,
    module.eu-west-2,
    module.us-east-1
  ]

  name = "${var.table_name}.${var.environment}"

  dynamic "replica" {
    for_each = var.region_names
    content {
      region_name = replica.value
    }
  }
}

output "GlobalTableName" {
  value = aws_dynamodb_global_table.ddb_global_table.name
}

# output "TableName" {
#   #   value = aws_dynamodb_table.ddb_table.name
#   value = {
#     for k, v in var.region_names : v => aws_dynamodb_table.ddb_table[v].name
#   }
# }

# output "GlobalTableName" {
#   value = aws_dynamodb_global_table.ddb_global_table.name
# }
