import json
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
        result = comprehend(comprehend_client, script)
        put_result(s3_client, result_bucket, key, result)

    return {}


def get_script(s3_client, script_bucket: str, key: str) -> str:
    print(f"{script_bucket=}")
    print(f"{key=}")
    response = s3_client.get_object(Bucket=script_bucket, Key=key)
    print(f"{response=}")
    return ""


def comprehend(comprehend_client, script: str) -> str:
    response = comprehend_client.detect_dominant_language(Text=script)
    print(f"{response=}")
    lang = response["Languages"][0]["LanguageCode"]
    result = comprehend_client.detect_sentiment(Text=script, LanguageCode=lang)
    print(f"{result=}")
    return json.dumps(result)


def put_result(s3_client, result_bucket: str, key: str, result: str) -> None:
    response = s3_client.put_object(Body=result.encode(), Bucket=result_bucket, Key=key)
    print(f"{response=}")
