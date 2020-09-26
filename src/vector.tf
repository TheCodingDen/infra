resource "kubernetes_daemonset" "vector" {
  metadata {
    name      = "vector"
    namespace = "default"
    labels = {
      ident = "logging-egress"
      type  = "supporting-service"
    }

    spec {
      selector {
        match_labels = {
          ident = "logging-egress"
          type  = "supporting-service"
        }
      }

      template {
        metadata {
          labels = {
            ident = "logging-egress"
            type = "supporting-service"
          }
        }

        spec {
          container {
            image = "timberio/vector:0.10.0"
            name  = "vector-logging-egress"

            resources {
              limits {
                cpu = "0.5"
              }
              requests {
                cpu = "250m"
                memory = "100Mi"
              }
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_config_map" "vector" {
  metadata {
    name = "vector-config"
  }

  data = {
    "primary.toml" = file("vector.toml")
  }
}