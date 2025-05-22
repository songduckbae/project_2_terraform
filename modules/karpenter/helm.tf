resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "v0.36.0"

  namespace         = "karpenter"
  create_namespace  = true

  values = [
    yamlencode({
      serviceAccount = {
        name = "karpenter"
        annotations = {
          "eks.amazonaws.com/role-arn" = aws_iam_role.karpenter_controller.arn
        }
      }
      settings = {
        clusterName     = var.cluster_name
        clusterEndpoint = var.cluster_endpoint
        aws = {
          defaultInstanceProfile = aws_iam_instance_profile.karpenter_node.name
        }
      }
    })
  ]
}