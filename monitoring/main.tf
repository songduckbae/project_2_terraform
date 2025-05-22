# # kube-prometheus-stack 설치
# resource "helm_release" "kube_prometheus_stack" {
#   name       = "kube-prometheus"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "kube-prometheus-stack"
#   namespace  = "monitoring"
#   create_namespace = true
# }

# # cloudwatch-exporter 설치
# resource "helm_release" "cloudwatch_exporter" {
#   name       = "cloudwatch-exporter"
#   repository = "https://prometheus-community.github.io/helm-charts"
#   chart      = "prometheus-cloudwatch-exporter"
#   namespace  = "monitoring"

#   values = [
#     yamlencode({
#       serviceAccount = {
#         create = false
#         name   = kubernetes_service_account.cloudwatch_exporter_sa.metadata[0].name
#       },
#       aws = {
#         region = var.region
#       },
#       metrics = [
#         {
#           aws_namespace     = "AWS/ApplicationELB"
#           aws_metric_name   = "RequestCount"
#           aws_dimensions    = ["LoadBalancer"]
#           aws_statistics    = ["Sum"]
#         },
#         {
#           aws_namespace     = "AWS/EBS"
#           aws_metric_name   = "VolumeReadBytes"
#           aws_dimensions    = ["VolumeId"]
#           aws_statistics    = ["Sum"]
#         }
#       ]
#     })
#   ]
# }