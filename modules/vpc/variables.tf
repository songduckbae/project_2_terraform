# vpc 전체 IP 주소 범위
variable "vpc_cidr" {
  description = "CIDR"
  type        = string
  default     = "10.10.10.0/24"
}

# vpc 이름
variable "vpc_name" {
  description = "Name"
  type        = string
  default     = "eks-vpc"
}

# 사용할 가용 영역 리스트트
variable "azs" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["ap-northeast-2a", "ap-northeast-2b", "ap-northeast-2c"]
}

# 퍼블릿 서브넷에 할당할 CIDR 리스트
variable "public_subnet_cidrs" {
  description = "List of CIDRs for public subnets"
  type        = list(string)
  default     = ["10.10.10.0/27", "10.10.10.32/27", "10.10.10.64/27"]
}

# 프라이빗 서브넷에 할당할 CIDR 리스트
variable "private_subnet_cidrs" {
  description = "List of CIDRs for private subnets"
  type        = list(string)
  default     = ["10.10.10.96/27", "10.10.10.128/27", "10.10.10.160/27"]
}