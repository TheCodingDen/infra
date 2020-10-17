resource "kubernetes_namespace" "modmail_ns" {
  metadata {
    name = "modmail"
  }
}

resource "kubernetes_deployment" "modmail_bot" {
  metadata {
    name      = "modmail-bot-deployment"
    namespace = kubernetes_namespace.modmail_ns.id
  }
  spec {
    selector {
      match_labels = {
        ident = "modmail-bot"
        type  = "discord-bot"
      }
    }
    template {
      metadata {
        labels = {
          ident = "modmail-bot"
          type  = "discord-bot"
        }
      }
      spec {
        container {
          image = "" # TODO: Get correct image
          name  = "modmail-bot"

          # TODO: Env vars
        }
      }
    }
  }
}
