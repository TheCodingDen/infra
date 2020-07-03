resource "kubernetes_persistent_volume_claim" "petit_data" {
  metadata {
    name = "petit_data"
  }
  spec {
    access_modes = ["ReadWriteOnce"] # ReadWriteMany and ReadOnlyMany is not supported
    resources {
      requests = {
        storage = "1Gi"
      }
    }
    storage_class_name = "do-block-storage"
  }
}

resource "kubernetes_pod" "hermes" {
    metadata {
        name = "hermes"
    }
    spec {
        container {
            image = "kantenkugel/hermes"
            name = "hermes"
        }
        volume {
            name = "petit_data"
            persistent_volume_claim {
                claim_name = kubernetes_persistent_volume_claim.petit_data.metadata[0].name
            }
        }
        volume_mount {
            name = "petit_data"
            mount_path = "/hermes/"
            sub_path = "/hermes/"
        }
    }
}