provider "aws" {
  region = "eu-central-1"
}

resource "aws_iam_user" "kubernetes_user" {
  name = "kubernetes-${var.environment}-demo-user"
}

resource "aws_iam_access_key" "kubernetes_user_access_key" {
  user = aws_iam_user.kubernetes_user.name
}

resource "aws_iam_policy" "kubernetes_policy" {
  name        = "kubernetes-${var.environment}-policy"
  description = "Policy for Kubernetes to access route53"
  policy      = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": "route53:GetChange",
      "Resource": "arn:aws:route53:::change/*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "route53:ChangeResourceRecordSets",
        "route53:ListResourceRecordSets"
      ],
      "Resource": "arn:aws:route53:::hostedzone/*"
    },
    {
      "Effect": "Allow",
      "Action": "route53:ListHostedZonesByName",
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_user_policy_attachment" "kubernetes_policy_attachment" {
  user       = aws_iam_user.kubernetes_user.name
  policy_arn = aws_iam_policy.kubernetes_policy.arn
}

output "access_key_id" {
  value = aws_iam_access_key.kubernetes_user_access_key.id
}

output "secret_access_key" {
  value     = aws_iam_access_key.kubernetes_user_access_key.secret
  sensitive = true
}

# EXAMPLE
# resource "aws_route53_record" "example_nextjs_production" {
#   zone_id = "YOUR_ZONE_ID" # Replace with your Route 53 Zone ID
#   name    = "example.com"
#   type    = "A"
#   ttl     = 300 # Time to live in seconds, adjust as needed

#   records = ["${var.cluster_ip}"] # Replace with the actual IP address
# }
