resource "helm_release" "karpenter" {
  name       = "karpenter"
  repository = "https://charts.karpenter.sh"
  chart      = "karpenter"
  version    = "0.16.3"

  namespace        = "karpenter"
  create_namespace = true

  set {
    name  = "serviceAccount.name"
    value = "karpenter"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter_controller.arn
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter_node.name
  }

  set {
    name  = "controller.args[0]"
    value = "--feature-gates=enableProvisionerV1=true"
  }

  set {
    name  = "controller.args[1]"
    value = "--cluster-name=${var.eks_cluster_name}"
  }

  set {
    name  = "controller.args[2]"
    value = "--cluster-endpoint=${var.eks_cluster_endpoint}"
  }
}