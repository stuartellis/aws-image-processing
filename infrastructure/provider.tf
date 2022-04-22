provider "aws" {
  default_tags {
    tags = {
      Stack = "aws-image-processing-infra"
    }
  }
}
