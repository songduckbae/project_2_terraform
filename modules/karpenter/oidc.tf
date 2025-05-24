data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster_auth" "eks" {
  name = var.eks_cluster_name
}

data "aws_iam_openid_connect_provider" "eks" {
  arn = var.oidc_provider_arn
}
