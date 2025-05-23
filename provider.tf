provider "aws" {
  region = "ap-northeast-2"
}

# 가격 조회용
provider "aws" {
  alias = "use1"
  region = "us-east-1"
}

provider "kubernetes" {
  alias = "eks"
  host                   = var.eks_cluster_endpoint != "https://dummy" ? var.eks_cluster_endpoint : null
  cluster_ca_certificate = var.eks_cluster_ca != "ZHVtbXk=" ? base64decode(var.eks_cluster_ca) : null
  token                  = var.eks_cluster_ca != "ZHVtbXk=" ? data.aws_eks_cluster_auth.eks.token : null
}

provider "helm" {
  alias = "eks"
  kubernetes {
    host                   = var.eks_cluster_endpoint != "https://dummy" ? var.eks_cluster_endpoint : null
    cluster_ca_certificate = var.eks_cluster_ca != "ZHVtbXk=" ? base64decode(var.eks_cluster_ca) : null
    token                  = var.eks_cluster_ca != "ZHVtbXk=" ? data.aws_eks_cluster_auth.eks.token : null
  }
}
data "aws_eks_cluster_auth" "eks" {
  name = var.eks_cluster_name
}

data "aws_eks_cluster" "eks" {
  name = var.eks_cluster_name
}