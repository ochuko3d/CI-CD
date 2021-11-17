resource "aws_security_group" "efs" {
  name = "${var.family}-efs"
  description = "Security Group"
  vpc_id = aws_vpc.main.id
  ingress {
    from_port = 2049
    to_port = 2049
    protocol = "tcp"
    security_groups = ["${aws_security_group.task-sg.id}"]
    # cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
resource "aws_efs_file_system" "efs" {
  creation_token = var.family
  tags = {
    Name = var.family
  }
}
# Associate Firewall to our EFS
resource "aws_efs_mount_target" "a" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.public.*.id[0]
  security_groups = ["${aws_security_group.efs.id}"]
}
resource "aws_efs_mount_target" "b" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.public.*.id[1]
  security_groups = ["${aws_security_group.efs.id}"]
}
resource "aws_efs_mount_target" "c" {
  file_system_id = aws_efs_file_system.efs.id
  subnet_id      = aws_subnet.public.*.id[2]
  security_groups = ["${aws_security_group.efs.id}"]
}