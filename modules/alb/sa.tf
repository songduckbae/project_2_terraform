# # IAM role 생성
# resource "aws_iam_role" "alb_sa_role" {
#   name = "eks-alb-controller-role"

#   assume_role_policy = jsonencode({
#     Version = "2012-10-17"
#     Statement = [
#       {
#         Effect = "Allow"
#         Principal = {
#           Federated = data.aws_iam_openid_connect_provider.oidc.arn
#         }
#         Action = "sts:AssumeRoleWithWebIdentity"
#         Condition = {
#           StringEquals = {
#             "${replace(data.aws_iam_openid_connect_provider.oidc.url, "https://", "")}:sub" = "system:serviceaccount:kube-system:aws-load-balancer-controller"
#           }
#         }
#       }
#     ]
#   })
# }

# # IAM 정책 연결 alb_controller 연결
# resource "aws_iam_role_policy_attachment" "alb_sa_attach" {
#   role       = aws_iam_role.alb_sa_role.name
#   policy_arn = aws_iam_policy.alb_controller.arn
# }

# # 서비스 어카운트 생성 
# resource "kubernetes_service_account" "alb_sa" {
#   metadata {
#     name      = "aws-load-balancer-controller"
#     namespace = "kube-system"
#     annotations = {
#       "eks.amazonaws.com/role-arn" = aws_iam_role.alb_sa_role.arn
#     }
#   }
# }

# # EKS 클러스터 정보 가져오기
# data "aws_eks_cluster" "eks" {
#   name = var.cluster_name
# }

# # EKS에서 자동 생성된 OIDC Provider 정보 가져오기
# data "aws_iam_openid_connect_provider" "oidc" {
#   url = data.aws_eks_cluster.eks.identity[0].oidc[0].issuer
# }
