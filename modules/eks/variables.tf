variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "univ-eks"
}

variable "cluster_version" {
  description = "Kubernetes version for EKS cluster"
  type        = string
  default     = "1.31"
}

variable "cluster_iam_role_name" {
  description = "Name of the IAM role for EKS control plane"
  type        = string
  default     = "eks-cluster-example"
}

variable "subnet_ids" {
  description = "List of subnet IDs for EKS cluster"
  type        = list(string)
}

# vpc 값 받아오기
variable "vpc_id" {
  type = string
}

variable "private_subnet_ids" {
  type = list(string)
}

variable "public_subnet_ids" {
  type = list(string)
}