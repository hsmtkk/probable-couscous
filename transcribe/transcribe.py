import os
import uuid

import boto3


def lambda_handler(event, context):
    print(f"{event=}")
    print(f"{context=}")

    client = boto3.client("transcribe")
    script_bucket = os.getenv("SCRIPT_BUCKET")

    for record in event["Records"]:
        s3_event = record["s3"]
        source_bucket = s3_event["bucket"]["name"]
        key = s3_event["object"]["key"]
        handle_record(client, source_bucket, key, script_bucket)

    return {}


def handle_record(
    transcribe_client, source_bucket: str, key: str, script_bucket: str
) -> None:
    print(f"{source_bucket=}")
    print(f"{key=}")
    print(f"{script_bucket=}")
    job_name = str(uuid.uuid4())
    media_url = f"s3://{source_bucket}/{key}"
    response = transcribe_client.start_transcription_job(
        TranscriptionJobName=job_name,
        Media={"MediaFileUri": media_url},
        OutputBucketName=script_bucket,
        IdentifyLanguage=True,
    )
    print(f"{response=}")
