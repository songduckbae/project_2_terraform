variable "eks_cluster_name" {
  description = "EKS cluster name"
  type        = string
}

variable "eks_cluster_endpoint" {
  type = string
}

variable "oidc_provider_arn" {
  description = "OIDC Provider ARN from EKS cluster"
  type        = string
}
# variable "karpenter_controller_role_arn" {
#   type = string
# }

# variable "karpenter_node_instance_profile" {
#   type = string
# }