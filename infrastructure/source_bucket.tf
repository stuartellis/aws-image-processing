resource "aws_s3_bucket" "image_source" {
  bucket = "${var.prefix}-image-source"
}

resource "aws_ssm_parameter" "image_source_bucket" {
  name  = "/image-processing/buckets/source/arn"
  type  = "String"
  value = aws_s3_bucket.image_source.arn
}
