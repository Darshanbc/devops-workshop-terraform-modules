resource "aws_iam_role" "ecr_pull" {
  count = var.ecr_repository_arn == null ? 0 : 1

  name_prefix = "workshop-ec2-ecr-pull-"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy" "ecr_pull" {
  count = var.ecr_repository_arn == null ? 0 : 1

  name = "pull-workshop-image"
  role = aws_iam_role.ecr_pull[count.index].name
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = "ecr:GetAuthorizationToken"
        Resource = "*"
      },
      {
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:BatchGetImage",
          "ecr:GetDownloadUrlForLayer",
        ]
        Resource = var.ecr_repository_arn
      },
    ]
  })
}

resource "aws_iam_instance_profile" "ecr_pull" {
  count = var.ecr_repository_arn == null ? 0 : 1

  name_prefix = "workshop-ec2-ecr-pull-"
  role        = aws_iam_role.ecr_pull[count.index].name

  depends_on = [aws_iam_role_policy.ecr_pull]
}
