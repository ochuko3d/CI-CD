# ---------------------------------------------------------------------------------------------------------------------
# VARIABLES
# ---------------------------------------------------------------------------------------------------------------------

variable "aws_region" {
  description = "The AWS region to create things in."
  
}


variable "stack" {
  description = "Name of the stack."
}

variable "vpc_cidr" {
  description = "CIDR for the VPC"
  
}

variable "az_count" {
  description = "Number of AZs to cover in a given AWS region"
  default     = "2"
}

variable "artifactbucket" {
  description = "artifact bucket names"
}

variable "db_password1" {
  description = "artifact bucket names"
}



# variable "container_image" {
#  description = "Docker image to run in the ECS cluster"
#  default     = "ibuchh/spring-petclinic-h2"
# }

variable "family" {
  description = "Family of the Task Definition"
  
}

variable "container_port" {
  description = "Port exposed by the docker image to redirect traffic to"
  default     = 8080
}

variable "task_count" {
  description = "Number of ECS tasks to run"
}

variable "fargate_cpu" {
  description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
  
}

variable "fargate_memory" {
  description = "Fargate instance memory to provision (in MiB)"

}

variable "fargate-task-service-role" {
  description = "Name of the stack."

}

variable "db_instance_type" {
  description = "RDS instance type"
  
}

variable "db_host" {
  description = "RDS DB host"
}
variable "db_user" {
  description = "RDS DB username"
}

variable "db_password" {
  description = "RDS DB password"
  
}

# variable "db_password" {
#   description = "RDS DB password"
# }

variable "db_profile" {
  description = "RDS Profile"
  default     = "mysql"
}

variable "db_initialize" {
  description = "RDS initialize"
  default     = "yes"
}

variable "cw_log_group" {
  description = "CloudWatch Log Group"
  default     = "nordcloud"
}

variable "cw_log_stream" {
  description = "CloudWatch Log Stream"
  default     = "fargate"
}

# Source repo name and branch

variable "source_repo_name" {
    description = "Source repo name"
    type = string
}

variable "source_repo_branch" {
    description = "Source repo branch"
    type = string
}


# Image repo name for ECR

variable "image_repo_name" {
    description = "Image repo name"
    type = string
}

variable "publicsubnets" {
  type = list(string)
  description = "The public subnets of the VPC"
}

variable "privatesubnets" {
  type = list(string)
  description = "The private subnets of the VPC"
}

variable "availability-zones" {
  type        = list(string)
  description = "A list of availability zones"
}
