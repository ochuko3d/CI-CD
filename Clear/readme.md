<!--Headings -->
# Customer Request
<!-- horizonal rule -->
___
<!-- body -->
##
The customer has made an additional request to remove all the post at a minute's notice.

<!--Headings -->
# Thought Process
<!-- body -->
##
We are currently using an external RDS for the database and would require the customer connects to data and clear the post table.

There are ideally 2 ways to clear a table 
<!-- body -->
##
<!--OL -->
1. One at a time meaning you have to be specific about what you are deleting.
    ```
        DELETE FROM table_name
        WHERE condition;
    ```

1. Truncate the table, which allows you to delete all data in a table.
    ```
        TRUNCATE [TABLE] table_name
    ```
We will be using the later.

<!--Headings -->
# Prerequisites
<!-- body -->
##

<!--OL -->
1. The lambda role needed by AWSCLI will be created during the terraform process and fixed in the script
1. All other necessary details like the subnet groups and SG will equall be modified for the customer afer the build.
1. The python function needed has been saved as clear.zip
1. The user will however have to unzip the lcear.app and  modify the ***rds_config.py*** file for the relevant config parameters like the password as this will be unique to them and zip the file back up.

<!--Headings -->
# Script
<!-- body -->
## 
About the script.
<!--OL -->
1. The first part is to create the lambda function, thats where we will modify the customers role, security group and subnets
    <!-- Github Markdown--->

    <!--Code Block-->

    ```aws cli
            aws lambda create-function --function-name  Cleartable --runtime python3.8 \
                        --zip-file fileb://clear.zip --handler clear.handler \
                        --role arn:aws:iam::123456789012:role/lambda-vpc-role \
                        --vpc-config SubnetIds=subnet-0532bb6758ce7c71f,subnet-d6b7fda068036e11f,SecurityGroupIds=sg-0897d5f549934c2fb
    ```
1. The second part will execute  the function
    <!-- Github Markdown--->

    <!--Code Block-->

    ```aws cli
            aws lambda invoke --function-name Cleartable output.txt
    ```
