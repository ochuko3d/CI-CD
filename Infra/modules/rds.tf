resource "aws_rds_cluster_instance" "instances" {
  cluster_identifier   = aws_rds_cluster.cluster.id
  count                = 1
  db_subnet_group_name = aws_db_subnet_group.subnet-group.name
  engine               = aws_rds_cluster.cluster.engine
  engine_version       = aws_rds_cluster.cluster.engine_version
  identifier           = "${var.stack}-${count.index}"
  instance_class       = "db.t3.small"
}


resource "aws_rds_cluster" "cluster" {
  availability_zones     = data.aws_availability_zones.azs.names
  cluster_identifier     = "${var.stack}-cluster"
  database_name          = var.stack
  db_subnet_group_name   = aws_db_subnet_group.subnet-group.name
  engine                 = "aurora-mysql"
  engine_version         = "5.7.mysql_aurora.2.03.2"
  master_password        = var.db_password
  master_username        = var.db_user
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.sg.id]
}

resource "aws_db_subnet_group" "subnet-group" {
  name       = var.stack
  subnet_ids = aws_subnet.private.*.id
 
}

# Add security group
resource "aws_security_group" "sg" {
  name = "${var.stack}-${var.stack}-db"

  ingress {
    description     = "TCP from Fargate"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  vpc_id = aws_vpc.main.id
}

output "cluster-endpoint-rw" {
  value = aws_rds_cluster.cluster.endpoint
}

output "master-user" {
  value = var.db_user
}

output "master-password" {
  value = var.db_password
}