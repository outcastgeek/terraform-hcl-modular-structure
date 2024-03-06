
terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.15.0"
    }
    googlebeta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.15.0" # for enabling private services access
    }
  }
}

provider "google" {
  project = var.project_id
}

# Create the Cloud Run Service(s)
resource "google_cloud_run_service" "default" {
  for_each = var.aws_goog_regions

  name     = "${var.service_name}-${each.value["goog_region"]}-${var.environment}"
  location = each.value["goog_region"]

  template {
    spec {
      containers {
        image = var.docker_image
        ports {
          name = var.ports_name
        }
        dynamic "env" {
          for_each = var.env_vars
          content {
            name  = env.value["EnvName"]
            value = env.value["EnvValue"]
          }
        }
        env {
          name  = "DYNAMODB_REGION"
          value = each.value["aws_region"]
        }
        env {
          name  = "AWS_REGION"
          value = each.value["aws_region"]
        }
        env {
          name  = "GOOG_REGION"
          value = each.value["goog_region"]
        }
        env {
          name  = "REGION_NAME"
          value = each.key
        }

        env {
          name  = "AWS_ACCESS_KEY_ID"
          value = var.aws_access_key_id
        }

        env {
          name  = "AWS_SECRET_ACCESS_KEY"
          value = var.aws_secret_access_key
        }

        env {
          name  = "ACCOUNT_HOST"
          value = "${lookup(var.account_hosts, each.key)}"
        }

        env {
          name  = var.backend_url_env_name
          value = "${lookup(var.backend_urls, each.key)}${var.backend_url_path}"
        }
      }
    }

    metadata {
      annotations = {
        "autoscaling.knative.dev/maxScale" = "${var.knative_maxscale}"
        "run.googleapis.com/client-name"   = "terraform"
      }
    }
  }

  traffic {
    percent         = 100
    latest_revision = true
  }
}

# Set service public
data "google_iam_policy" "noauth" {
  binding {
    role = "roles/run.invoker"
    members = [
      "allUsers",
    ]
  }
}

resource "google_cloud_run_service_iam_policy" "noauth" {
  for_each = var.aws_goog_regions

  location = google_cloud_run_service.default[each.key].location
  project  = google_cloud_run_service.default[each.key].project
  service  = google_cloud_run_service.default[each.key].name


  policy_data = data.google_iam_policy.noauth.policy_data
  depends_on  = [google_cloud_run_service.default]
}

# Display the service URL
output "service_url" {
  value = {
    for k, v in var.aws_goog_regions : k => google_cloud_run_service.default[k].status[0].url
  }
}
