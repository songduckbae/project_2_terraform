
# resource "kubernetes_persistent_volume_claim_v1" "class_pvc" {
#   metadata {
#     name = "class-pvc"
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

# resource "kubernetes_deployment_v1" "class_deploy" {
#   metadata {
#     name = "class-deploy"
#     labels = {
#       app = "class"
#     }
#   }

#   spec {
#     replicas = 3
#     selector {
#       match_labels = {
#         app = "class"
#       }
#     }
#     template {
#       metadata {
#         labels = {
#           app = "class"
#         }
#       }
#       spec {
#         container {
#           name  = "class-ctn"
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
#             name       = "class-volume"
#             mount_path = "/data"
#           }
#         }
#         volume {
#           name = "class-volume"
#           persistent_volume_claim {
#             claim_name = kubernetes_persistent_volume_claim_v1.cert_pvc.metadata[0].name
#           }
#         }
#       }
#     }
#   }
# }

# resource "kubernetes_service_v1" "class_service" {
#   metadata {
#     name = "class-service"
#   }
#   spec {
#     selector = {
#       app = "class"
#     }
#     port {
#       protocol    = "TCP"
#       port        = 80
#       target_port = 80
#     }
#   }
# }