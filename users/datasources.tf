data "aws_ssm_parameter" "image_source_bucket" {
  name = "/image-processing/buckets/source/arn"
}

data "aws_ssm_parameter" "image_target_bucket" {
  name = "/image-processing/buckets/target/arn"
}
