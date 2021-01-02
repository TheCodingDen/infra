resource "kubernetes_namespace" "utilities_bot_ns" {
  metadata {
    name = "utilities-bot"
  }
}

resource "kubernetes_deployment" "utilities_bot" {
  metadata {
    name      = "utilities-bot-deployment"
    namespace = kubernetes_namespace.utilities_bot_ns.id
  }
  spec {
    selector {
      match_labels = {
        ident = "utilities-bot"
        type  = "discord-bot"
      }
    }
    template {
      metadata {
        labels = {
          ident = "utilities-bot"
          type  = "discord-bot"
        }
      }
      spec {
        container {
          image = "thecodingden/tcd-utilities-bot"
          name  = "utilities-bot"

          env {
            name  = "TOKEN"
            value = var.utilities_bot_token
          }

          dynamic "env" {
            for_each = var.utilities_bot_env_vars

            content {
              name  = env.key
              value = env.value
            }
          }
        }
      }
    }
  }
}
