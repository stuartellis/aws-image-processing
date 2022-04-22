# aws-image-processing

Terraform for image processing with S3.

## Requirements

- Terraform 1.1.8
- Python 3.9

## Set Up

1. Vendor a copy of the *exif* library for Python:

    pip3 install -r ./infrastructure/lambda/requirements.txt --target ./infrastructure/lambda/src

2. Change the working directory to *infrastructure/* and use the standard Terraform commands:

    terraform init
    terraform plan
    terraform apply

3. To provision the users, change the working directory to *users/* and use the standard Terraform commands:

    terraform init
    terraform plan
    terraform apply

## Design

This project uses Terraform and Python. It avoids using additional tools.

> CI/CD and Terraform remote state are out of scope for this exercise.

For simplicity, this project builds the Lambda using Terraform to ZIP and upload the code. We can use a deployment package without a Lambda layer, since we are deploying a single application with a single dependency. In a production situation, we would expect to manage the code with external processes.

The Lambda itself uses the Python library [exif](https://pypi.org/project/exif/) to process images. Images are handled in-memory, rather than round-tripping with temporary storage.
