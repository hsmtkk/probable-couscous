import os

import boto3


def lambda_handler(event, context):
    print(f"{event=}")
    print(f"{context=}")

    comprehend_client = boto3.client("comprehend")
    s3_client = boto3.client("s3")
    result_bucket = os.getenv("RESULT_BUCKET")

    for record in event["Records"]:
        s3_event = record["s3"]
        script_bucket = s3_event["bucket"]["name"]
        key = s3_event["object"]["key"]
        script = get_script(s3_client, script_bucket, key)

    return {}


def get_script(s3_client, script_bucket: str, key: str) -> str:
    print(f"{script_bucket=}")
    print(f"{key=}")
    response = s3_client.get_object(Bucket=script_bucket, Key=key)
    print(f"{response=}")
    return ""


# https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/comprehend/client/detect_dominant_language.html
# https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/comprehend/client/detect_sentiment.html
