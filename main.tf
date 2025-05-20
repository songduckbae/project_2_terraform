# vpc 모듈 호출
module "vpc" {
    source = "./modules/vpc"
}

# eks 모듈 호출
module "eks" {
    source = "./modules/eks"
    vpc_id = module.vpc.vpc_id
    public_subnet_ids = module.vpc.public_subnet_ids
    private_subnet_ids = module.vpc.private_subnet_ids
    subnet_ids = module.vpc.public_subnet_ids
}

#  VPC 정보 조회
data "aws_vpc" "eks_vpc" {
  filter {
    name   = "tag:Name"
    values = ["eks-vpc"]
  }
}

#  ALB 모듈 호출
# module "alb" {
#   source       = "./modules/alb"
#   cluster_name = module.eks.cluster_name
#   region       = var.region
#   vpc_id       = data.aws_vpc.eks_vpc.id
# }