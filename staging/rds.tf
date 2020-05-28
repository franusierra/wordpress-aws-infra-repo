resource "aws_db_instance" "wordpress_db" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "5.7"
  instance_class       = "db.t3.micro"
  vpc_security_group_ids = ["${aws_security_group.sg_rds.id}"]
  name                 = var.db_name
  username             = var.db_user
  password             = var.db_password
  parameter_group_name = "default.mysql5.7"
  final_snapshot_identifier = "wordpress-snapshot"
}
