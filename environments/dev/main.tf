
## Locals

locals {
  environment    = "dev"
  version        = "v1"
  sessions_table = "mywebapp_sessions"
  posts_table    = "mywebapp_posts"
  comments_table = "mywebapp_comments"
  users_table    = "mywebapp_users"
  roles_table    = "mywebapp_roles"
  metrics_table    = "mywebapp_metrics"
}

## AWS Location

module "my_web_app_location" {
  source = "../../aws/location"
  here_index_name = var.here_index_name
  here_index_use = var.here_index_use
  esri_index_name = var.esri_index_name
  esri_index_use = var.esri_index_use
}

output "mywebapp_here_index_name" {
  value = module.my_web_app_location.mywebapp_here_index
}

output "mywebapp_esri_index_name" {
  value = module.my_web_app_location.mywebapp_esri_index
}

## AWS DynamoDB

module "mywebapp_sessions" {
  source = "../../aws/dynamodb/v1"

  table_name  = "${local.sessions_table}.${local.version}"
  environment = local.environment
}

output "Sessions_TableName" {
  value = module.mywebapp_sessions.GlobalTableName
}

module "mywebapp_posts" {
  source = "../../aws/dynamodb/v1"

  table_name  = "${local.posts_table}.${local.version}"
  environment = local.environment
}

output "Posts_TableName" {
  value = module.mywebapp_posts.GlobalTableName
}

module "mywebapp_comments" {
  source = "../../aws/dynamodb/v1"

  table_name  = "${local.comments_table}.${local.version}"
  environment = local.environment
}

output "Comments_TableName" {
  value = module.mywebapp_comments.GlobalTableName
}

module "mywebapp_roles" {
  source = "../../aws/dynamodb/v1"

  table_name  = "${local.roles_table}.${local.version}"
  environment = local.environment
}

output "Roles_TableName" {
  value = module.mywebapp_roles.GlobalTableName
}

module "mywebapp_metrics" {
  source = "../../aws/dynamodb/v1"

  table_name  = "${local.metrics_table}.${local.version}"
  environment = local.environment
}

output "Metrics_TableName" {
  value = module.mywebapp_metrics.GlobalTableName
}

module "mywebapp_users" {
  source = "../../aws/dynamodb/v1"

  table_name  = "${local.users_table}.${local.version}"
  environment = local.environment
}

output "Users_TableName" {
  value = module.mywebapp_users.GlobalTableName
}

## Google Cloud Run

# APPNAME=my.webapp
# SVCNAME=my-web-app-web
# APINAME=my-web-app-api
# PROJECTID=my-webapp
# gcr.io/$(PROJECTID)/$(APPNAME)/$(SVCNAME)

resource "random_password" "app_secret" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "random_password" "session_secret" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

module "my_web_app_api" {
  source = "../../goog/cloudrun-deploy"

  project_id = "my-webapp"
  # docker_image = "gcr.io/my-webapp/my.webapp/my-web-app-api" # Latest by Defalut
  docker_image = "gcr.io/my-webapp/my.webapp/my-web-app-api:latest"
  service_name = "my-web-app-api"

  environment      = "dev"
  knative_maxscale = "3"

  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key

  env_vars = {
    "api_env" = {
      EnvName  = "my.webapp_API_ENV"
      EnvValue = "dev"
    },
    "api_port" = {
      EnvName  = "my.webapp_API_PORT"
      EnvValue = "8080"
    },
    "api_host" = {
      EnvName  = "my.webapp_API_HOST"
      EnvValue = ""
    },
    "app_secret" = {
      EnvName  = "APP_SECRET"
      EnvValue = random_password.app_secret.result # "32-byte-long-auth-key"
    },
    "sessions_table" = {
      EnvName  = "SESSIONS_TABLE"
      EnvValue = "${local.sessions_table}.${local.version}.${local.environment}"
    },
    "posts_table" = {
      EnvName  = "POSTS_TABLE"
      EnvValue = "${local.posts_table}.${local.version}.${local.environment}"
    },
    "comments_table" = {
      EnvName  = "COMMENTS_TABLE"
      EnvValue = "${local.comments_table}.${local.version}.${local.environment}"
    },

    "algolia_application_id" = {
      EnvName  = "ALGOLIA_APPLICATION_ID"
      EnvValue = var.algolia_application_id
    },

    "algolia_api_key" = {
      EnvName  = "ALGOLIA_API_KEY"
      EnvValue = var.algolia_api_key
    },
  }
}

output "api_urls" {
  value = module.my_web_app_api.service_url
}

module "my_web_app_web" {
  source = "../../goog/cloudrun-deploy"

  project_id = "my-webapp"
  # docker_image = "gcr.io/my-webapp/my.webapp/my-web-app-web" # Latest by Default
  docker_image = "gcr.io/my-webapp/my.webapp/my-web-app-web:latest"
  service_name = "my-web-app-web"

  environment      = "dev"
  knative_maxscale = "3"

  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key

  account_hosts = module.my_web_app_webapp.service_url

  backend_url_env_name = "GQL_URL"
  backend_url_path     = "/api/query"
  backend_urls         = module.my_web_app_api.service_url

  ports_name = "h2c"

  env_vars = {
    "node_env" = {
      EnvName  = "NODE_ENV"
      EnvValue = "production"
    },
    "use_http2" = {
      EnvName = "USE_HTTP2"
      EnvValue = "true"
    }
    "app_secret" = {
      EnvName  = "APP_SECRET"
      EnvValue = random_password.session_secret.result # "32-byte-long-auth-key"
    },
    "web_host" = {
      EnvName  = "ADDRESS"
      EnvValue = "0.0.0.0"
    },
    "web_backlog" = {
      EnvName  = "BACKLOG"
      EnvValue = 511
    },
    "metrics_table" = {
      EnvName  = "METRICS_TABLE"
      EnvValue = "${local.metrics_table}.${local.version}.${local.environment}"
    },
    "roles_table" = {
      EnvName  = "ROLES_TABLE"
      EnvValue = "${local.roles_table}.${local.version}.${local.environment}"
    },
    "users_table" = {
      EnvName  = "USERS_TABLE"
      EnvValue = "${local.users_table}.${local.version}.${local.environment}"
    },
    "posts_table" = {
      EnvName  = "POSTS_TABLE"
      EnvValue = "${local.posts_table}.${local.version}.${local.environment}"
    },
    "comments_table" = {
      EnvName  = "COMMENTS_TABLE"
      EnvValue = "${local.comments_table}.${local.version}.${local.environment}"
    },
    "algolia_application_id" = {
      EnvName  = "ALGOLIA_APPLICATION_ID"
      EnvValue = var.algolia_application_id
    },

    "algolia_api_key" = {
      EnvName  = "ALGOLIA_API_KEY"
      EnvValue = var.algolia_api_key
    },
  }
}
output "web_urls" {
  value = module.my_web_app_web.service_url
}

module "my_web_app_webapp" {
  source = "../../goog/cloudrun-deploy"

  project_id = "my-webapp"
  # docker_image = "gcr.io/my-webapp/my.webapp/my-web-app-webapp" # Latest by Default
  docker_image = "gcr.io/my-webapp/my.webapp/my-web-app-webapp:latest"
  service_name = "my-web-app-webapp"

  environment      = "dev"
  knative_maxscale = "3"

  aws_access_key_id     = var.aws_access_key_id
  aws_secret_access_key = var.aws_secret_access_key

  env_vars = {
    "jwt_key" = {
      EnvName  = "JWT_KEY"
      EnvValue = random_password.session_secret.result # "32-byte-long-jwt-key"
    },
    "roles_table" = {
      EnvName  = "ROLES_TABLE"
      EnvValue = "${local.roles_table}.${local.version}.${local.environment}"
    },
    "users_table" = {
      EnvName  = "USERS_TABLE"
      EnvValue = "${local.users_table}.${local.version}.${local.environment}"
    },
    "posts_table" = {
      EnvName  = "POSTS_TABLE"
      EnvValue = "${local.posts_table}.${local.version}.${local.environment}"
    },
    "comments_table" = {
      EnvName  = "COMMENTS_TABLE"
      EnvValue = "${local.comments_table}.${local.version}.${local.environment}"
    },

    "algolia_application_id" = {
      EnvName  = "ALGOLIA_APPLICATION_ID"
      EnvValue = var.algolia_application_id
    },

    "algolia_api_key" = {
      EnvName  = "ALGOLIA_API_KEY"
      EnvValue = var.algolia_api_key
    },
  }
}
output "webapp_urls" {
  value = module.my_web_app_webapp.service_url
}
