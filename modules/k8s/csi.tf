# resource "helm_release" "ebs_csi" {
#   name       = "aws-ebs-csi-driver"
#   namespace  = "kube-system"
#   repository = "https://kubernetes-sigs.github.io/aws-ebs-csi-driver"
#   chart      = "aws-ebs-csi-driver"
#   version    = "2.26.1"

#   set {
#     name  = "controller.serviceAccount.create"
#     value = "true"
#   }

#   set {
#     name  = "controller.serviceAccount.name"
#     value = "ebs-csi-controller-sa"
#   }

#   set {
#     name  = "node.serviceAccount.create"
#     value = "true"
#   }

# }
