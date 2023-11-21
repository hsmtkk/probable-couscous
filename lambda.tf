data "archive_file" "transcribe" {
  type        = "zip"
  source_dir  = "${path.module}/transcribe"
  output_path = "${path.module}/transcribe.zip"
}

resource "aws_lambda_function" "transcribe" {
  function_name    = "${var.unique_prefix}-transcribe"
  handler          = "transcribe.lambda_handler"
  runtime          = "python3.11"
  filename         = data.archive_file.transcribe.output_path
  source_code_hash = filebase64sha256(data.archive_file.transcribe.output_path)
  role             = aws_iam_role.transcribe.arn
  environment {
    variables = {
      SCRIPT_BUCKET = aws_s3_bucket.script.id
    }
  }
}

resource "aws_lambda_permission" "transcribe" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.transcribe.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.source.arn
}

data "archive_file" "comprehend" {
  type        = "zip"
  source_dir  = "${path.module}/comprehend"
  output_path = "${path.module}/comprehend.zip"
}

resource "aws_lambda_function" "comprehend" {
  function_name    = "${var.unique_prefix}-comprehend"
  handler          = "comprehend.lambda_handler"
  runtime          = "python3.11"
  filename         = data.archive_file.comprehend.output_path
  source_code_hash = filebase64sha256(data.archive_file.comprehend.output_path)
  role             = aws_iam_role.comprehend.arn
  environment {
    variables = {
      RESULT_BUCKET = aws_s3_bucket.result.id
    }
  }
}

resource "aws_lambda_permission" "comprehend" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.comprehend.arn
  principal     = "s3.amazonaws.com"
  source_arn    = aws_s3_bucket.script.arn
}
