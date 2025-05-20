resource "kubernetes_storage_class_v1" "pj_sc" {
  metadata {
    name = "pj-sc"
  }
  storage_provisioner = "ebs.csi.aws.com"
  reclaim_policy = "Delete"
  volume_binding_mode = "WaitForFirstConsumer"
  

  parameters = {
    type = "gp3"
  }
}

resource "kubernetes_persistent_volume_claim_v1" "cert_pvc" {
  metadata {
    name = "cert-pvc"
  }
  spec {
    access_modes = ["ReadWriteOnce"]
    resources {
      requests = {
        storage = "5Gi"
      }
    }
    storage_class_name = kubernetes_storage_class_v1.pj_sc.metadata[0].name
  }
}

resource "kubernetes_deployment_v1" "cert_deploy" {
  metadata {
    name = "cert-deploy"
    labels = {
      app = "cert"
    }
  }

  spec {
    replicas = 3
    selector {
      match_labels = {
        app = "cert"
      }
    }
    template {
      metadata {
        labels = {
          app = "cert"
        }
      }
      spec {
        container {
          name  = "cert-ctn"
          image = "nginx"
          port {
            container_port = 80
          }
          resources {
            limits = {
              memory = "1Gi"
              cpu    = "1"
            }
            requests = {
              memory = "1Gi"
              cpu    = "1"
            }
          }
          volume_mount {
            name       = "cert-volume"
            mount_path = "/data"
          }
        }
        volume {
          name = "cert-volume"
          persistent_volume_claim {
            claim_name = kubernetes_persistent_volume_claim_v1.cert_pvc.metadata[0].name
          }
        }
      }
    }
  }
}

resource "kubernetes_service_v1" "cert_service" {
  metadata {
    name = "cert-service"
  }
  spec {
    selector = {
      app = "cert"
    }
    port {
      protocol    = "TCP"
      port        = 80
      target_port = 80
    }
  }
}