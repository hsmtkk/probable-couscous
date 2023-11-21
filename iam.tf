data "aws_iam_policy_document" "lambda" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "transcribe" {
  name                = "transcribe-${var.unique_suffix}"
  assume_role_policy  = data.aws_iam_policy_document.lambda.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/AmazonTranscribeFullAccess", "arn:aws:iam::aws:policy/AmazonS3FullAccess"]
}

resource "aws_iam_role" "comprehend" {
  name                = "comprehend-${var.unique_suffix}"
  assume_role_policy  = data.aws_iam_policy_document.lambda.json
  managed_policy_arns = ["arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole", "arn:aws:iam::aws:policy/AmazonS3FullAccess"]
}