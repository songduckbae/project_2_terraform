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
