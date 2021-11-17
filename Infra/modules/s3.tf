# Build an AWS S3 bucket for s3 artifact
resource "aws_s3_bucket" "codepipeline_artifacts" {
  bucket = "${var.artifactbucket}-ochuko-nord-poc"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }

  # Neede for CloudWatch
  versioning {
    enabled = true
  }
}

# Build an AWS S3 bucket for logging
resource "aws_s3_bucket" "s3_logging_bucket" {
  bucket = "${var.artifactbucket}-s3-logging-bucket"
  acl    = "private"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "aws:kms"
      }
    }
  }
}


output "artifactbucket" {
  value = aws_s3_bucket.codepipeline_artifacts.bucket
}
output "artifactbucketarn" {
  value = aws_s3_bucket.codepipeline_artifacts.arn
}

output "s3_logging_bucket_id" {
  value = aws_s3_bucket.s3_logging_bucket.id
}
output "s3_logging_bucket" {
  value = aws_s3_bucket.s3_logging_bucket.bucket
}
