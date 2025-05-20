# eks 클러스터 설정
resource "aws_eks_cluster" "univ_eks" {
  name     = var.cluster_name
  version  = var.cluster_version

  access_config {
    authentication_mode = "API"
  }

  role_arn = aws_iam_role.univ_eks_role.arn

  vpc_config {
    subnet_ids = var.private_subnet_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.univ_eks_role_attachment
  ]
}

resource "aws_iam_role" "univ_eks_role" {
  name = "univ_eks_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sts:AssumeRole",
          "sts:TagSession"
        ]
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_iam_role_policy_attachment" "univ_eks_role_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.univ_eks_role.name
}

# eks node group 설정
resource "aws_eks_node_group" "univ_ng" {
  cluster_name    = aws_eks_cluster.univ_eks.name
  node_group_name = "univ_ng"
  node_role_arn   = aws_iam_role.univ_nodegroup_role.arn
  subnet_ids      = var.private_subnet_ids
  instance_types = ["t3.small"]

  scaling_config {
    desired_size = 3
    max_size     = 3
    min_size     = 3
  }

  update_config {
    max_unavailable = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.univ-ng-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.univ-ng-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.univ-ng-AmazonEC2ContainerRegistryReadOnly         # example- 이게 맞나?
  ]

  tags = {
    "Name" = "univ-ng-node"   
  }

  labels = {
    "eks/nodegroup-name" = "univ_ng"
  }

  tags_all = {
    "Name" = "univ-ng-node"
  }
}

resource "aws_iam_role" "univ_nodegroup_role" {
  name = "univ_nodegroup_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "univ-ng-AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.univ_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "univ-ng-AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.univ_nodegroup_role.name
}

resource "aws_iam_role_policy_attachment" "univ-ng-AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.univ_nodegroup_role.name
}

# # # mainfest를 이용해서 테라폼에서 yml 파일 사용하기
# #테라폼에게 나는 쿠버네티스 리소스를 다룰거야 선언언
# provider "kubernetes" {
#   config_path = "~/.kube/config"  # 쿠버네티스 클러스터에 접속하기 위한 kubeconfig 파일 경로 지정/ 로컬에 저장된 kubeconfig 경로
# }

# # StorageClass (공통)
# resource "kubernetes_manifest" "sc" {
#   manifest = yamldecode(file("${path.module}/csi.yml"))
# }

# # PVC
# resource "kubernetes_manifest" "cert_pvc" {
#   manifest = yamldecode(file("${path.module}/certpvc.yml"))
# }

# resource "kubernetes_manifest" "class_pvc" {
#   manifest = yamldecode(file("${path.module}/classpvc.yml"))
# }

# resource "kubernetes_manifest" "home_pvc" {
#   manifest = yamldecode(file("${path.module}/homepvc.yml"))
# }

# # Deployments 
# resource "kubernetes_manifest" "cert_deploy" {
#   manifest = yamldecode(file("${path.module}/certdeploy.yml"))
# }

# resource "kubernetes_manifest" "class_deploy" {
#   manifest = yamldecode(file("${path.module}/classdeploy.yml"))
# }

# resource "kubernetes_manifest" "home_deploy" {
#   manifest = yamldecode(file("${path.module}/homedeploy.yml"))
# }

# # Service
# resource "kubernetes_manifest" "cert_service" {
#   manifest = yamldecode(file("${path.module}/certsvc.yml"))
# }

# resource "kubernetes_manifest" "class_service" {
#   manifest = yamldecode(file("${path.module}/classsvc.yml"))
# }

# resource "kubernetes_manifest" "home_service" {
#   manifest = yamldecode(file("${path.module}/homesvc.yml"))
# }

# resource "kubernetes_manifest" "ingress" {
#   manifest = yamldecode(file("${path.module}/ingress.yml"))
# }