#!/bin/bash
echo "Downloading the get repository, let the show begin"
git clone https://github.com/ochuko3d/Nordcloud.git  
cd Nordcloud/Infra

echo "Getting the Aururo RDS DB Password, this will be stored in AWS SSM" 
read -p "enter the RDS Aurora database password: " password
aws ssm put-parameter --name production.nordcloud.ghost --value $password --type SecureString
terraform init
terraform apply -auto-approve 
export lb_address=$(terraform output lb_address)
echo "The load balancer address: " $lb_address
echo "changing directories"
export repository=$(terraform output repository)
cd ..
cd ghost
read -p "enter your username: " username
read -p "enter your email: " email

echo "working on the git stuff almost done"
git config --global user.name "$username"
git config --global user.email $email
git init
git add .
git commit -m "firstly"
#For authentication purposes, we will use AWS IAM git credential helper
git config --system --unset credential.helper
git config --global credential.helper '!aws codecommit credential-helper $@'
git config --global credential.UseHttpPath true
git remote add origin ${repository//\"/}
git remote -v
git push -u origin master
echo "The load balancer addressto connect to: " $lb_address


