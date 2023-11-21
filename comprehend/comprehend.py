import boto3


def lambda_handler(event, context):
    print(f"{event=}")
    print(f"{context=}")
    client = boto3.client("comprehend")
    return {}
