
variable "aws_region" {
  description = "The AWS region to create things in."
  default     = "eu-west-1"
}

variable "statebucket" {
    description = "The name of the bucket. "
    type        = string

}
