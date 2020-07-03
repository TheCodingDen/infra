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
            persistent_volume_claim {
                claim_name = kubernetes_persistent_volume_claim.data.metadata[0].name
            }
        }
    }
}