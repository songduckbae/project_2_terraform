#!/bin/bash

set -e

# 1. VPC + EKS 초기 배포
echo "[1/6] VPC + EKS 클러스터 생성 중..."
terraform apply -target=module.vpc -auto-approve
terraform apply -target=module.eks -auto-approve

# 2. 클러스터 출력값 받아오기
echo "[2/6] EKS 클러스터 정보 추출 중..."
export EKS_CLUSTER_ENDPOINT=$(terraform output -raw cluster_endpoint)
export EKS_CLUSTER_CA=$(terraform output -raw cluster_ca)
export EKS_CLUSTER_NAME=$(terraform output -raw cluster_name)

# 2-1. 인증서 유효성 검사
if [[ "$EKS_CLUSTER_CA" == "ZHVtbXk=" || -z "$EKS_CLUSTER_CA" ]]; then
  echo "❌ 에러: 인증서 값이 비어있거나 dummy 상태입니다. 클러스터 출력값을 확인하세요."
  exit 1
fi

# 2-2. PEM 유효성 검사
if ! echo "$EKS_CLUSTER_CA" | base64 --decode 2>/dev/null | grep -q "BEGIN CERTIFICATE"; then
  echo "❌ 에러: 인증서가 유효한 PEM 형식이 아닙니다. base64 값이 잘못된 것 같습니다."
  exit 1
fi

# 3. 클러스터 활성화 및 kubeconfig 설정
echo "[3/6] 클러스터 활성화 대기 및 kubeconfig 설정 중..."
aws eks wait cluster-active --name "$EKS_CLUSTER_NAME" --region ap-northeast-2
aws eks update-kubeconfig --region ap-northeast-2 --name "$EKS_CLUSTER_NAME"

# 4. Karpenter Helm Chart만 먼저 설치 (CRD 생성 포함)
echo "[4/6] Karpenter Helm 차트 (CRD 포함) 설치 중..."
terraform apply -target=module.karpenter.helm_release.karpenter \
  -var="eks_cluster_endpoint=$EKS_CLUSTER_ENDPOINT" \
  -var="eks_cluster_ca=$EKS_CLUSTER_CA" \
  -var="eks_cluster_name=$EKS_CLUSTER_NAME" \
  -auto-approve

# 4-1. CRD 등록까지 약간 대기
echo "⏳ CRD 등록 대기 중... (20초)"
sleep 20

# 5. 전체 리소스 최종 적용 (ALB, K8s, Provisioner 포함)
echo "[5/6] 전체 리소스 최종 적용 중..."
terraform apply \
  -var="eks_cluster_endpoint=$EKS_CLUSTER_ENDPOINT" \
  -var="eks_cluster_ca=$EKS_CLUSTER_CA" \
  -var="eks_cluster_name=$EKS_CLUSTER_NAME" \
  -auto-approve

# 6. 완료 메시지
echo "[6/6] ✅ 모든 리소스가 성공적으로 배포되었습니다."
