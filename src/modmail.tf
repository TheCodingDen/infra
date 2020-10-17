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

resource "kubernetes_deployment" "modmail_web" {
  metadata {
    name      = "modmail-web-deployment"
    namespace = kubernetes_namespace.modmail_ns.id
  }
  spec {
    selector {
      match_labels = {
        ident = "modmail-web"
        type  = "website"
      }
    }
    template {
      metadata {
        labels = {
          ident = "modmail-web"
          type  = "website"
        }
      }
      spec {
        container {
          image = "" # TODO: Get correct image
          name  = "modmail-web"

          # TODO: Env vars
        }
      }
    }
  }
}

resource "kubernetes_service" "modmail_web_service" {
    metadata {
        name = "modmail_web"
    }
    spec {
        selector = {
            ident = kubernetes_deployment.modmail_web.spec.0.selector.labels["ident"]
            type = kubernetes_deployment.modmail_web.spec.0.selector.labels["type"]
        }
        session_affinity = "ClientIP"
        port {
            port        = 8080
            target_port = 80
        }

        type = "LoadBalancer"
    }
}
