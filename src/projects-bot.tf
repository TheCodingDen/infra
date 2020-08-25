resource "kubernetes_persistent_volume_claim" "data" {
  metadata {
    name = "data"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    storage_class_name = "do-block-storage"
  }
}

resource "kubernetes_pod" "projects-bot" {
  metadata {
    name = "projects-bot"
  }
  spec {
    container {
      image = "thecodingden/projects-bot"
      name  = "projects-bot"

      env {
        name  = "DISCORD_CLIENT_TOKEN"
        value = var.projects_bot_token
      }

      dynamic "env" {
        for_each = var.projects_bot_env_vars

        content {
          name  = env.key
          value = env.value
        }
      }
    }
    volume {
      name = "data"
      persistent_volume_claim {
        claim_name = kubernetes_persistent_volume_claim.data.metadata[0].name
      }
    }
  }
}
