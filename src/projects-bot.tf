resource "kubernetes_namespace" "projects_bot_ns" {
  metadata {
    name = "projects-bot"
  }
}

resource "kubernetes_persistent_volume_claim" "data" {
  metadata {
    name      = "projects-bot-pvc"
    namespace = kubernetes_namespace.projects_bot_ns.id
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

resource "kubernetes_deployment" "projects_bot" {
  metadata {
    name      = "projects-bot-deployment"
    namespace = kubernetes_namespace.projects_bot_ns.id
  }
  spec {
    selector {
      match_labels = {
        ident = "projects-bot"
        type = "discord-bot"
      }
    }
    template {
      metadata {
        labels = {
          ident = "projects-bot"
          type = "discord-bot"
        }
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
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim.data.metadata[0].name
          }
        }
      }
    }
  }
}
