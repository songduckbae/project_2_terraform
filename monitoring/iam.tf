# resource "aws_iam_policy" "cloudwatch_metrics_policy" {
#   name = "CloudWatchMetricsAccess"

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Effect = "Allow",
#         Action = [
#           "cloudwatch:GetMetricData",
#           "cloudwatch:ListMetrics",
#           "ec2:DescribeTags"
#         ],
#         Resource = "*"
#       }
#     ]
#   })
# }

# resource "aws_iam_role_policy_attachment" "attach" {
#   role       = aws_iam_role.cloudwatch_exporter_role.name
#   policy_arn = aws_iam_policy.cloudwatch_metrics_policy.arn
# }