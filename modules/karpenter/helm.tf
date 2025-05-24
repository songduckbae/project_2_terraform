# resource "helm_release" "karpenter" {
#   name       = "karpenter"
#   repository = "https://charts.karpenter.sh"
#   chart      = "karpenter"
#   version    = "0.16.3"

#   namespace        = "karpenter"
#   create_namespace = true

#   set {
#     name  = "serviceAccount.name"
#     value = "karpenter"
#   }

#   set {
#     name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
#     value = aws_iam_role.karpenter_controller.arn
#   }

#   set {
#     name  = "settings.aws.defaultInstanceProfile"
#     value = aws_iam_instance_profile.karpenter_node.name
#   }


#   set {
#     name  = "controller.env[0].name"
#     value = "CLUSTER_NAME"
#   }
#   set {
#     name  = "controller.env[0].value"
#     value = var.cluster_name
#   }
#   set {
#     name  = "controller.env[1].name"
#     value = "CLUSTER_ENDPOINT"
#   }
#   set {
#     name  = "controller.env[1].value"
#     value = var.cluster_endpoint
#   }
# }


#0.33 이상 버젼부터 노드풀, ec2 클래스 사용 가능능
resource "helm_release" "karpenter" {
  name       = "karpenter"
  namespace  = "karpenter"
  chart      = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  version    = "1.4.0"
  create_namespace = true
  timeout = 600
  wait    = true

  set {
    name  = "settings.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "settings.clusterEndpoint"
    value = var.cluster_endpoint
  }

  set {
    name  = "settings.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter_node.name
  }

  set {
    name  = "settings.interruptionQueueName"
    value = aws_sqs_queue.karpenter_interruption.name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter_controller.arn
  }
}
