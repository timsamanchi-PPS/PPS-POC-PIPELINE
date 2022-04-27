
data "aws_iam_policy" "permissions_boundary" {
    arn = "arn:aws:iam::714102873737:policy/pps.global.iamrp.ConanPermissionBoundaryPolicy"
}
resource "aws_iam_role" "tf-codepipeline-role" {
  name = "tf-codepipeline-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
        Service = "codepipeline.amazonaws.com"
        }
      },
    ]
  })

  permissions_boundary = data.aws_iam_policy.permissions_boundary.arn

  tags = {
    Name = "tf-codepipeline-role"
  }
}

data "aws_iam_policy_document" "tf-cicd-pipeline-policies" {
  statement {
    sid = "statement1"
    effect = "Allow"
    resources = ["*"]
    actions = ["codestar-connections:UseConnection"]
  }
  statement {
    sid = "statement2"
    effect = "Allow"
    resources = ["*"]
    actions = ["s3:*","codebuild:*","cloudwatch:*"]
  }
}

resource "aws_iam_policy" "tf-cicd-pipeline-policy" {
  description = "pipeline policy"
  name = "tf-cicd-pipeline-policy"
  path = "/"
  policy = data.aws_iam_policy_document.tf-cicd-pipeline-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-pipeline-attachment" {
  role = aws_iam_role.tf-codepipeline-role.name
  policy_arn = aws_iam_policy.tf-cicd-pipeline-policy.arn
}

resource "aws_iam_role" "tf-codebuild-role" {
  name = "tf-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
        Service = "codebuild.amazonaws.com"
        }
      },
    ]
  })

  permissions_boundary = data.aws_iam_policy.permissions_boundary.arn

  tags = {
    Name = "tf-codebuild-role"
  }
}

data "aws_iam_policy_document" "tf-cicd-build-policies" {
  statement {
    sid = "statement1"
    effect = "Allow"
    resources = ["*"]
    actions = ["s3:*","iam:*","logs:*","codebuild:*","secretsmanager:*"]
  }
}

resource "aws_iam_policy" "tf-cicd-build-policy" {
  description = "build policy"
  name = "tf-cicd-build-policy"
  path = "/"
  policy = data.aws_iam_policy_document.tf-cicd-build-policies.json
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment1" {
  role = aws_iam_role.tf-codebuild-role.id
  policy_arn = aws_iam_policy.tf-cicd-build-policy.arn
}

resource "aws_iam_role_policy_attachment" "tf-cicd-codebuild-attachment2" {
  role = aws_iam_role.tf-codebuild-role.id
  policy_arn = "arn:aws:iam::aws:policy/PowerUserAccess"
}