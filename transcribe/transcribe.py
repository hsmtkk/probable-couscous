import boto3


def lambda_handler(event, context):
    print(f"{event=}")
    print(f"{context=}")

    client = boto3.client("transcribe")

    for record in event["Records"]:
        bucket = record["bucket"]["name"]
        key = record["object"]["key"]
        handle_record(client, bucket, key)

    return {}


def handle_record(transcribe_client, bucket: str, key: str) -> None:
    print(f"{bucket=}")
    print(f"{key=}")
