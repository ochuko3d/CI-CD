provider "aws" {
  region = var.aws_region
}

data "aws_availability_zones" "azs" {
  filter {
    name   = "opt-in-status"
    values = ["opt-in-not-required"]
  }
}

module "modules" {
  source                    = "./modules"
  stack                     = "ghostproduction"
  image_repo_name           = "ghostproduction"
  source_repo_name          = "ghostproduction"
  source_repo_branch        = "master"
  aws_region                = "eu-west-1"
  family                    = "ghostproduction"
  fargate_cpu               = 256
  fargate_memory            = 512
  task_count                = 2
  db_host                   = module.modules.cluster-endpoint-rw
  db_user                   = "johnprice"
  availability-zones        = data.aws_availability_zones.azs.names
  fargate-task-service-role = "production-role"
  db_password               = data.aws_ssm_parameter.dbpassword.value
  db_password1              = module.modules.master-password
  db_instance_type          = "db.t2.small"
  vpc_cidr                  = "192.168.0.0/16"
  publicsubnets             = ["192.168.1.0/24", "192.168.2.0/24", "192.168.3.0/24"]
  privatesubnets            = ["192.168.11.0/24", "192.168.12.0/24", "192.168.13.0/24"]
  artifactbucket            = "productionochukonordcloud"
  container_port            = 2368
}

output "repository" {
  value = module.modules.source_repo_clone_url_http
}
    
output "lb_address" {
  value = module.modules.alb_address
}

output "lb_arn" {
  value = module.modules.alb_arn
}

output "image_repo" {
  value = module.modules.image_repo_url
}

output "image_repoarn" {
  value = module.modules.image_repo_arn
}    
