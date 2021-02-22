variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}

resource "digitalocean_kubernetes_cluster" "main" {
  name    = "arealmreborn"
  region  = "ams3"
  version = "1.17.5-do.0"

  node_pool {
    name       = "primal"
    size       = "s-1vcpu-2gb"
    auto_scale = true
    min_nodes  = 1
    max_nodes  = 5
  }
}

provider "kubernetes" {
  host                   = digitalocean_kubernetes_cluster.main.endpoint
  token                  = digitalocean_kubernetes_cluster.main.kube_config[0].token
  cluster_ca_certificate = base64decode(digitalocean_kubernetes_cluster.main.kube_config.0.cluster_ca_certificate)
}

terraform {
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "TheCodingDen"

    workspaces {
      name = "infra"
    }
  }
}
