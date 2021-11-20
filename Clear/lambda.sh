#!/bin/bash
aws lambda create-function --function-name  Cleartable --runtime python3.8 \
--zip-file fileb://clear.zip --handler clear.handler \
--role arn:aws:iam::123456789012:role/lambda-vpc-role \
--vpc-config SubnetIds=subnet-0532bb6758ce7c71f,subnet-d6b7fda068036e11f,SecurityGroupIds=sg-0897d5f549934c2fb

aws lambda invoke --function-name Cleartable output.txt