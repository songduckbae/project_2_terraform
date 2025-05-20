# # ALB 설치할 때 필요한 IAM 정책 정의
# # 외부 데이터를 가져와서 읽기 전용으로 사용하는 용도 = data
# # url 주소 받아와서 json으로 사용해서 파일 내용 접근근
# data "http" "alb_policy" {
#   url = "https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.7.1/docs/install/iam_policy.json"
# }

# # ALB 컨트롤러 전용 IAM 정책 생성
# resource "aws_iam_policy" "alb_controller" {
#   name   = "AWSLoadBalancerControllerIAMPolicy"
#   policy = data.http.alb_policy.response_body
# }
