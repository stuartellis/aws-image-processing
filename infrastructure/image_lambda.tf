data "archive_file" "image_lambda_zip" {
  type        = "zip"
  source_dir  = "lambda/src"
  output_path = "lambda/output/${var.image_function_name}.zip"
}

resource "aws_cloudwatch_log_group" "image_lambda" {
  name              = "/aws/lambda/${var.image_function_name}"
  retention_in_days = var.log_retention_days
}

resource "aws_iam_role" "image_lambda" {
  name = "${title(var.prefix)}ImageLambdaRole"

  inline_policy {
    name = "ImageLambdaPolicy"

    policy = jsonencode({
      Version = "2012-10-17"
      Statement = [
        {
          Action = [
            "logs:CreateLogGroup",
            "logs:CreateLogStream",
            "logs:PutLogEvents"
          ]
          Effect   = "Allow"
          Resource = "${aws_cloudwatch_log_group.image_lambda.arn}:*"
        },
        {
          Action = [
            "s3:GetObject"
          ]
          Effect   = "Allow"
          Resource = "${aws_s3_bucket.image_source.arn}/*"
        },
        {
          Action = [
            "s3:PutObject"
          ]
          Effect   = "Allow"
          Resource = "${aws_s3_bucket.image_target.arn}/*"
        }
      ]
    })
  }

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })
}

resource "aws_lambda_function" "image_lambda" {
  filename         = data.archive_file.image_lambda_zip.output_path
  function_name    = var.image_function_name
  handler          = var.handler
  source_code_hash = data.archive_file.image_lambda_zip.output_base64sha256
  runtime          = var.runtime
  role             = aws_iam_role.image_lambda.arn

  environment {
    variables = {
      TARGET_BUCKET_NAME = "${var.prefix}-image-target"
    }
  }
}

resource "aws_lambda_permission" "allow_source_bucket" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.image_lambda.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.image_source.arn
}

resource "aws_s3_bucket_notification" "bucket_notification" {
  bucket = aws_s3_bucket.image_source.id

  lambda_function {
    lambda_function_arn = aws_lambda_function.image_lambda.arn
    events              = ["s3:ObjectCreated:*"]
    filter_suffix       = ".jpg"
  }

  depends_on = [aws_lambda_permission.allow_source_bucket]
}
