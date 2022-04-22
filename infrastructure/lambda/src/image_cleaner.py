import json
import os
import urllib.parse

from io import BytesIO

import boto3

from exif import Image


def handler(event, context):
    s3_client = boto3.client("s3")

    bucket = event["Records"][0]["s3"]["bucket"]["name"]
    key = urllib.parse.unquote_plus(
        event["Records"][0]["s3"]["object"]["key"], encoding="utf-8"
    )

    print(f"FILE DETECTED: {key}")

    try:
        response = s3_client.get_object(Bucket=bucket, Key=key)
        print(f"FILE CONTENT TYPE: {response['ContentType']}")

    except Exception as e:
        print(f"ERROR getting {key} from bucket {bucket}.")
        raise e

    try:
        image = Image(BytesIO(response["Body"].read()))
    except Exception as e:
        print(f"ERROR getting content for {key}.")
        raise e

    try:
        if image.has_exif:
            image.delete_all()
    except Exception as e:
        print(f"ERROR removing EXIF data for {key}.")
        raise e

    try:
        cleaned_image = image.get_file()
        cleaned_obj = BytesIO(cleaned_image)
        s3_client.upload_fileobj(
            Fileobj=cleaned_obj,
            Bucket=os.environ["TARGET_BUCKET_NAME"],
            Key=key,
        )

    except Exception as e:
        print(
            f"ERROR uploading object {key} to bucket {os.environ['TARGET_BUCKET_NAME']}."
        )
        raise e
