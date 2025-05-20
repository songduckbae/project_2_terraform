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

# terraform {
#   required_providers {
#     kubernetes = {
#       source = "hashicorp/kubernetes"
#     }
#     helm = {
#       source = "hashicorp/helm"
#     }
#   }
# }