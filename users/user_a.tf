resource "aws_iam_user" "a" {
  name = "user-a"
}

resource "aws_iam_user_policy" "a" {
  name = "ImageUserAPolicy"
  user = aws_iam_user.a.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject",
          "s3:PutObject"
        ]
        Effect   = "Allow"
        Resource = "${data.aws_ssm_parameter.image_source_bucket.value}/*"
      }
    ]
  })
}
