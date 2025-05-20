# resource "kubernetes_storage_class_v1" "pj_sc" {
#   metadata {
#     name = "pj-sc"
#   }
#   storage_provisioner = "ebs.csi.aws.com"
#   reclaim_policy = "Delete"
#   volume_binding_mode = "WaitForFirstConsumer"
  

#   parameters = {
#     type = "gp3"
#   }
# }

# resource "kubernetes_persistent_volume_claim_v1" "cert_pvc" {
#   metadata {
#     name = "home-pvc"
#   }
#   spec {
#     access_modes = ["ReadWriteOnce"]
#     resources {
#       requests = {
#         storage = "5Gi"
#       }
#     }
#     storage_class_name = kubernetes_storage_class_v1.pj_sc.metadata[0].name
#   }
# }

# resource "kubernetes_deployment_v1" "cert_deploy" {
#   metadata {
#     name = "home-deploy"
#     labels = {
#       app = "home"
#     }
#   }

#   spec {
#     replicas = 3
#     selector {
#       match_labels = {
#         app = "home"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = "home"
#         }
#       }
#       spec {
#         container {
#           name  = "home-ctn"
#           image = "nginx"
#           port {
#             container_port = 80
#           }
#           resources {
#             limits = {
#               memory = "1Gi"
#               cpu    = "1"
#             }
#             requests = {
#               memory = "1Gi"
#               cpu    = "1"
#             }
#           }
#           volume_mount {
#             name       = "home-volume"
#             mount_path = "/data"
#           }
#         }
#         volume {
#           name = "home-volume"
#           persistent_volume_claim {
#             claim_name = kubernetes_persistent_volume_claim_v1.cert_pvc.metadata[0].name
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service_v1" "cert_service" {
#   metadata {
#     name = "home-service"
#   }
#   spec {
#     selector = {
#       app = "home"
#     }
#     port {
#       protocol    = "TCP"
#       port        = 80
#       target_port = 80
#     }
#   }
# }