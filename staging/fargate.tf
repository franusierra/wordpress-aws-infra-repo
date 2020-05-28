resource "aws_ecs_cluster" "main" {
  name = "wordpress-cluster"
}

resource "aws_ecs_task_definition" "wordpress" {
  family                   = "wordpress"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = "256"
  memory                   = "512"
  execution_role_arn       = aws_iam_role.ecs_tasks_execution_role.arn
  container_definitions = <<DEFINITION
    [
      {
        "image": "${var.image}",
        "name": "wordpress",
        "networkMode": "host",
        "portMappings": [
          {
            "containerPort": 80,
            "hostPort": 80
          }
        ],
        "secrets": [{
          "name": "WORDPRESS_DB_NAME",
          "valueFrom": "${aws_ssm_parameter.staging_db_name.arn}"
        },
        {
          "name": "WORDPRESS_DB_USER",
          "valueFrom": "${aws_ssm_parameter.staging_user.arn}"
        },
        {
          "name": "WORDPRESS_DB_PASSWORD",
          "valueFrom": "${aws_ssm_parameter.staging_password.arn}"
        }
        ],
        "environment": [
          {
            "name": "WORDPRESS_DB_HOST",
            "value": "${aws_db_instance.wordpress_db.endpoint}"
          }
        ]
      }
    ]
DEFINITION

}


resource "aws_ecs_service" "wordpress_staging" {
  name            = "wordpress_staging"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.wordpress.arn
  desired_count   = 2
  launch_type     = "FARGATE"
  network_configuration {
    assign_public_ip  = true
    security_groups   = ["${aws_security_group.sg_ecs.id}"]
    subnets           = var.subnet_id
  }
  load_balancer {
    target_group_arn = aws_alb_target_group.app.id
    container_name   = "wordpress"
    container_port   = 80
  }
  depends_on = [aws_alb_listener.front_end, aws_iam_role.ecs_tasks_execution_role]
}