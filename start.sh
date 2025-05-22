# #!/bin/bash
# set -e

# terraform init

# if [ ! -f "terraform.tfstate" ]; then
#   echo "❌ 상태 파일 없음! init이 제대로 실행되지 않았습니다."
#   exit 1
# fi

# echo " Applying VPC"
# terraform apply -target=module.vpc -auto-approve

# echo " Applying EKS"
# terraform apply -target=module.eks -auto-approve

# echo " Applying K8S"
# terraform apply -target=module.k8s -auto-approve

# echo " Applying ALB"
# terraform apply -target=module.alb -auto-approve

# echo " Applying Karpenter"
# terraform apply -target=module.karpenter -auto-approve

# echo " 모든 구성 완료! "