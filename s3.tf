resource "aws_s3_bucket" "source" {
  bucket        = "${var.unique_prefix}-source"
  force_destroy = true
}

resource "aws_s3_bucket" "script" {
  bucket        = "${var.unique_prefix}-script"
  force_destroy = true
}

resource "aws_s3_bucket" "result" {
  bucket        = "${var.unique_prefix}-result"
  force_destroy = true
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

resource "aws_s3_bucket_lifecycle_configuration" "source" {
  bucket = aws_s3_bucket.source.id
  rule {
    id     = "rule-0"
    status = "Enabled"
    expiration {
      days = 1
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "script" {
  bucket = aws_s3_bucket.script.id
  rule {
    id     = "rule-0"
    status = "Enabled"
    expiration {
      days = 1
    }
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "result" {
  bucket = aws_s3_bucket.result.id
  rule {
    id     = "rule-0"
    status = "Enabled"
    expiration {
      days = 1
    }
  }
}