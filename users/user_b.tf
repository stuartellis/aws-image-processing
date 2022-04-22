resource "aws_iam_user" "b" {
  name = "user-b"
}

resource "aws_iam_user_policy" "b" {
  name = "ImageUserBPolicy"
  user = aws_iam_user.b.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "s3:GetObject"
        ]
        Effect   = "Allow"
        Resource = "${data.aws_ssm_parameter.image_target_bucket.value}/*"
      }
    ]
  })
}
