resource "aws_s3_bucket" "source" {
  bucket = "source-${var.unique_suffix}"
}

resource "aws_s3_bucket" "script" {
  bucket = "script-${var.unique_suffix}"
}

resource "aws_s3_bucket" "result" {
  bucket = "result-${var.unique_suffix}"
}

resource "aws_s3_bucket_notification" "source" {
  bucket = aws_s3_bucket.source.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.transcribe.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.transcribe]
}

resource "aws_s3_bucket_notification" "script" {
  bucket = aws_s3_bucket.script.id
  lambda_function {
    lambda_function_arn = aws_lambda_function.comprehend.arn
    events              = ["s3:ObjectCreated:*"]
  }
  depends_on = [aws_lambda_permission.comprehend]
}
