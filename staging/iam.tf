
data "aws_iam_policy_document" "ecs_tasks_execution_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}
resource "aws_iam_role" "ecs_tasks_execution_role" {
  name               = "staging-ecs-task-execution-role"
  assume_role_policy = "${data.aws_iam_policy_document.ecs_tasks_execution_role.json}"
}
resource "aws_iam_role_policy_attachment" "ecs_tasks_execution_role" {
  role       = "${aws_iam_role.ecs_tasks_execution_role.name}"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
data "aws_iam_policy_document" "ssm_policy" {
  statement {
    actions   = ["ssm:GetParameters","ssm:GetParameter"]
    resources = [
      aws_ssm_parameter.staging_user.arn,
      aws_ssm_parameter.staging_password.arn,
      aws_ssm_parameter.staging_db_name.arn
    ]
  }
}
resource "aws_iam_policy" "policy_ssm_wordpress_db" {
  name = "ssm-policy-wordpress-db"
  policy = "${data.aws_iam_policy_document.ssm_policy.json}"
}
resource "aws_iam_role_policy_attachment" "attachment_policy_ssm" {
  role       = "${aws_iam_role.ecs_tasks_execution_role.name}"
  policy_arn = aws_iam_policy.policy_ssm_wordpress_db.arn

}