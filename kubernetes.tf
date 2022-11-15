#---root/kubernetes.tf---

resource "kubernetes_deployment" "week20projectk8s" {
  metadata {
    name = "week20projectk8s"
    labels = {
      test = "week20project_test"
    }
  }

  spec {
    replicas = 2
    selector {
      match_labels = {
        test = "week20project_test"
      }
    }
    template {
      metadata {
        labels = {
          test = "week20project_test"
        }
      }
      spec {
        container {
          image = "nginx:1.7.8"
          name  = "week20projectk8s"

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

resource "kubernetes_service" "week20projectk8s" {
  metadata {
    name = "week20projectk8s"
  }

  spec {
    selector = {
      test = "week20project_test"
    }
    port {
      port        = 80
      target_port = 80
      node_port   = 30010
    }

    type = "LoadBalancer"
  }
}
