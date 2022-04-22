resource "aws_s3_bucket" "image_target" {
  bucket = "${var.prefix}-image-target"
}

resource "aws_ssm_parameter" "image_target_bucket" {
  name  = "/image-processing/buckets/target/arn"
  type  = "String"
  value = aws_s3_bucket.image_target.arn
}
