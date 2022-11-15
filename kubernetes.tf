#---root/kubernetes.tf---

resource "kubernetes_deployment" "krypt0-week20-k8s" {
  metadata {
    name = "krypt0-week20-k8s"
    labels = {
      test = "krypt0-week20-app"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        test = "krypt0-week20-app"
      }
    }
    template {
      metadata {
        labels = {
          test = "krypt0-week20-app"
        }
      }
      spec {
        container {
          image = "nginx:1.7.8"
          name  = "krypt0-week20-k8s"

          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "50Mi"
            }
          }
        }
      }
    }
  }
}

resource "kubernetes_service" "krypt0-week20-k8s" {
  metadata {
    name = "krypt0-week20-k8s"
  }

  spec {
    selector = {
      test = "krypt0-week22-app"
    }
    port {
      port        = 80
      target_port = 80
      node_port   = 30010
    }

    type = "LoadBalancer"
  }
}
