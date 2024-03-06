
## DEV Environment

module "dev" {
  source                 = "./environments/dev"
  aws_access_key_id      = var.aws_access_key_id
  aws_secret_access_key  = var.aws_secret_access_key
  algolia_application_id = var.algolia_application_id
  algolia_api_key        = var.algolia_api_key
}

output "dev_sessions_tablename" {
  value = module.dev.Sessions_TableName
}

output "dev_posts_tablename" {
  value = module.dev.Posts_TableName
}

output "dev_comments_tablename" {
  value = module.dev.Comments_TableName
}

output "dev_roles_tablename" {
  value = module.dev.Roles_TableName
}

output "dev_users_tablename" {
  value = module.dev.Users_TableName
}

output "dev_api_urls" {
  value = module.dev.api_urls
}

output "dev_web_urls" {
  value = module.dev.web_urls
}

output "dev_webapp_urls" {
  value = module.dev.webapp_urls
}

## STAGING Environment

# module "staging" {
#   source                = "./environments/staging"
#   aws_access_key_id     = var.aws_access_key_id
#   aws_secret_access_key = var.aws_secret_access_key
# }

# output "staging_sessions_tablename" {
#   value = module.staging.Sessions_TableName 
# }

# output "staging_posts_tablename" {
#   value = module.staging.Posts_TableName 
# }

# output "staging_comments_tablename" {
#   value = module.staging.Comments_TableName 
# }

# output "staging_api_urls" {
#   value = module.staging.api_urls
# }

# output "staging_web_urls" {
#   value = module.staging.web_urls
# }

## PRODUCTION Environment

# module "production" {
#   source                = "./environments/production"
#   aws_access_key_id     = var.aws_access_key_id
#   aws_secret_access_key = var.aws_secret_access_key
# }

# output "production_sessions_tablename" {
#   value = module.production.Sessions_TableName 
# }

# output "production_posts_tablename" {
#   value = module.production.Posts_TableName 
# }

# output "production_comments_tablename" {
#   value = module.production.Comments_TableName 
# }

# output "production_api_urls" {
#   value = module.production.api_urls
# }

# output "production_web_urls" {
#   value = module.production.web_urls
# }
