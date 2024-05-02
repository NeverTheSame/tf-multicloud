# Define the required permissions in an IAM policy
resource "aws_iam_policy" "s3_list_policy" {
  name        = "S3ListObjectsPolicy"
  description = "Policy to allow listing objects in a specific S3 bucket."

  # Policy document
  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "s3:ListBucket"
        ],
        Resource = [
          "arn:aws:s3:::tf-state-serverocm-bucket" # Specify your bucket ARN
        ]
      },
      {
        Effect = "Allow",
        Action = [
          "s3:GetObject"
        ],
        Resource = [
          "arn:aws:s3:::tf-state-serverocm-bucket/*" # Specify your bucket objects ARN
        ]
      }
    ]
  })
}

# Output the created policy ARN
output "s3_list_policy_arn" {
  value = aws_iam_policy.s3_list_policy.arn
}
