
<!--Headings -->
# Background
<!-- horizonal rule -->
___
<!-- body -->
##
Drone shuttle have reached out to us and after going through their requirement the following requirements have been infered and are critical for their new platfoem modernization.

<!-- horizonal rule -->
___

<!--OL -->
1. A serverless infrastructure that would need little or no managemental effort to keep their platform running.
1. The Infrastructure should be able to scale on demand when the traffic increase/ spikes on their platform.
1. A disaster recovering mechanism ensuring the Platform remain geographical available in the event of region downtime.
1. The ability for the platform to be available globally and still secured.
1. A Continous Integration/Continous Deployment (CI/CD) process where their devops engineer can depoly multiple release with no downtime.
1. The ability to deploy multiple environment and tools to ensure thy are monitored while been seperated, and do debugging
1. The customer has a special request to delete multiple blog post from the database with a severless function

<!-- horizonal rule -->
___

<!--Headings -->
# Thought Process
<!-- body -->
##

The need to maintain a serverless infrastructure with minimal maintainance needed, that would automatically scale required me using ECS, elastic container services, running on Fargate. This was equally a great optiion seeing as the company wanted to deploy their application in a CI/CD pattern. 
<!-- UL -->
* **elastic container services**: This is used to run the container images and indifferent availability ones. The deployment style will be blue/green deployment

To enable a virtual CI/CD pattern for the devops and multiple environments, the following was used

<!-- UL -->
* **codecommit**: AWS properiary git repository to manage the companies sourse codes.
* **code pipeline**: To manage the source to deploy process code build.
* **artifact bucket**: An S#3 artifact and log bucket will be created and used
* **code build**: to build the docker images and push to AWS Elastic Container Registry(ECR)
* **Elastic Container Registry**: This is used to hold the new images after there have been built.

To ensure high availabilty and protect the data incase of an availability zone loss the  following were used :
<!-- UL -->
* **RDS**: An RDS cluster running 1 instance is used, and has been added to the ecs task definition to enable automatic connection during a new build or deployment to preserve data.
* **EFS**: Elastic file storage to keep the images and content safe during a new deployment.


To ensure traffic distribution I thought of the following
<!-- UL -->
* **Application Load Balancer**: unencrypted traffic is distributed to the load balancer target group, which comprises of ecs container running in different Availability zones (az)

* **Cloudfront**: This will be used for content delivery across the globe by providing caching. It will also provide an extra layer of security by providing a WAF and help protect again DDCO attack.

* **Route53**: This is used to deploy the domain name 

To add an extra layer of security the following where done used
<!-- UL -->
* **Nat Gateway**: this is used for enabling the *ECS clusters* deployed in the private subnet to talk witht the internet
* **IAM**: strict IAM roles and policies were used to ensure the principle of *least priveledges* was adhered to.

To build the infrastructure as code **Terraform** was used and to automate the various process a **bash script** was used

<!--Headings -->
# Prerequisites
<!-- body -->
##
<!--OL -->
1. An Amazon Account, a set of credentials with Administrator permissions. ***Note***: In a production environment I would recommend locking permissions down to the bare minimum needed to operate the pipeline.
1. AWS-CLI, you can check the version installed, then install it if not already installed
    ```
        aws --version
        pip install awscli --upgrade --user
    ```
    Run aws configure to configure your credntials
    ```
        $ aws configure
        AWS Access Key ID [None]: 
        AWS Secret Access Key [None]: 
        Default region name [None]: us-east-1
        Default output format [None]: 
1. Download and install Terraform:
    ```
        wget https://releases.hashicorp.com/terraform/0.13.4/terraform_0.13.4_linux_amd64.zip
        unzip terraform_0.13.4_linux_amd64.zip
        sudo mv terraform /usr/local/bin/
        export PATH=$PATH:/usr/local/bin/terraform
    ```


<!--Headings -->
# Architecture

<!--image-->
![Architecture Diagram](https://github.com/ochuko3d/Nordcloud/blob/main/Images/Architecture.jpeg)

<!-- horizonal rule -->
___
<!-- body -->
##
<!--OL -->
1. In the beginning they was terraform and it did wonders as an IaC tool, it built this amazing infrastructure that enables replication and easy deployment of services by using modules. The following services will be lauched.

        <!--tables-->
        |     CICD            |     Network      |  Data | Storage     |
        | ------------------- |------------------| ----- |-------------|
        | Code Deploy         | Internet Gateway | SSM   | EFS         |
        | Code Commit         | NAT Gateway      |       | RDS Cluster |
        | Code Pipeline       | VPC              |       |             |    
        | Container Registry  | Internet Gateway |       |             |
        | Code Commit         | NAT Gateway      |       |             |
        | Container Service   | Priv/Pub subnets |       |             |
        |                     | Route Tables     |       |             |
        |                     | Appliction-LB    |       |             |
        |                     | Route53          |       |             |
        |                     | Security Group   |       |             |

1. The Network infrastructure is deployed with a secure and a fault tolerance approach, by having multiple subnets in 3 availabilities zones. Nat Gateways were deployed in each of the 3 public subnets to enable the ecs and anyother services running in the private subnet can communicate over the internet without been exposed. Security Groups we used to protect the DBs and allow only traffic from the ECS cluster.

1. The CI/CD deployment is linked to the ***master*** branch, meaning you can have multiple branches per environment application code, but a build and deployment will only be triggered when a commit via the ***console or git push*** is carried out on the master branch.

1. The final stage after the deployment takes place, the container are placed behind the load balancer by using the target group.
<!--Headings -->
# Implementation Checklist

<!--tables-->

| Completed Task                   | Uncompleted Task             | 
| -------------------------------- |----------------------------- | 
| <!-- tasklist -->                |<!-- tasklist -->             |
|  [*] CodePipeline                | [ ] Cloudfront               | 
|  [*] CodeBuild                   | [ ] Route53                  |
|  [*] CodeCommit                  | [ ] ECS Blue/Green Deployment|
|  [*] Elastic Code Registry       |                              |  
|  [*] IAM Policies                |                              |
|  [*] NAT Gateway                 |                              |
|  [*] Secured-VPC                 |                              |
|  [*] Application Load Balancer   |                              |
|  [*] RDS                         |                              |
|  [*] EFS                         |                              |
|  [*] ECS                         |                              |
|  [*] S3 Bucket                   |                              |

<!--Headings -->
# Script

<!-- body -->
## 
The sript is in 3 phase
<!--OL -->
1. The first phase is to create the backend bucket  and dynamodb that would be used by terraform to maintain the state-file of the project. This will prevent 2 devops engineer from launching together

1. The Second phase is launching the infrastructure for the environment.
1. The final part is pushing the dockerfile for ghost to the repo.

