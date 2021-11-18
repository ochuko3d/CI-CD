provider "aws" {
  region = "eu-west-1"
}


resource "aws_dynamodb_table" "terraform-state" {
 name           = "${var.bucket}-dynamodb"
 read_capacity  = 10
 write_capacity = 10
 hash_key       = "LockID"

 attribute {
   name = "LockID"
   type = "S"
 }
}

/*
 resource "aws_kms_key" "terraform-bucket-key1" {
 description             = "This key is used to encrypt bucket objects"
 deletion_window_in_days = 10
 enable_key_rotation     = true
}

resource "aws_kms_alias" "key-alias" {
 name          = "alias/${var.bucket}"
 target_key_id = aws_kms_key.terraform-bucket-key1.id
}*/


resource "aws_s3_bucket" "terraform-state" {
 bucket = "${var.bucket}-terraformstate-ochuko"
 acl    = "private"

 lifecycle {
     prevent_destroy = false
 }

 versioning {
   enabled = true
 }
/*
 server_side_encryption_configuration {
   rule {
     apply_server_side_encryption_by_default {
       kms_master_key_id = aws_kms_key.terraform-bucket-key1.id
       sse_algorithm     = aws_kms_key.terraform-bucket-key1.id == "" ? "AES256" : "aws:kms"
     }
   }
 }
 */
}

resource "aws_s3_bucket_public_access_block" "block" {
 bucket = aws_s3_bucket.terraform-state.id

 block_public_acls       = true
 block_public_policy     = true
 ignore_public_acls      = true
 restrict_public_buckets = true
}

output "statebucket" {
  value = aws_s3_bucket.terraform-state.id
}
