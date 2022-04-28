# 
# create aws-codebuild project for terraform plan and apply
# creat 3 stage CI/CD aws-codepipeline 
#
# terraform plan
resource "aws_codebuild_project" "tf-plan" {
    description = "plan stage for terraform"
    name = "tf-cicd-plan"
    service_role = aws_iam_role.tf-codebuild-role.arn

    artifacts {
      type = "CODEPIPELINE"
    }

    environment {
      compute_type = "BUILD_GENERAL1_SMALL"
      image = "hashicorp/terraform:0.14.3"
      type = "LINUX_CONTAINER"
      image_pull_credentials_type = "SERVICE_ROLE"
      registry_credential {
        credential = var.dockerHub-credentials
        credential_provider = "SECRETS_MANAGER"
      }
    }
    source {
      type = "CODEPIPELINE"
      buildspec = file("buildspec/plan-buildspec.yml")
    }
}

# terraform apply
resource "aws_codebuild_project" "tf-apply" {
    description = "apply stage for terraform"
    name = "tf-cicd-apply"
    service_role = aws_iam_role.tf-codebuild-role.arn

    artifacts {
      type = "CODEPIPELINE"
    }

    environment {
      compute_type = "BUILD_GENERAL1_SMALL"
      image = "hashicorp/terraform:0.14.3"
      type = "LINUX_CONTAINER"
      image_pull_credentials_type = "SERVICE_ROLE"
      registry_credential {
        credential = var.dockerHub-credentials
        credential_provider = "SECRETS_MANAGER"
      }
    }
    source {
      type = "CODEPIPELINE"
      buildspec = file("buildspec/apply-buildspec.yml")
    }
}

# aws-codepipeline
resource "aws_codepipeline" "cicd-pipeline" {
    name = "tf-cicd"
    role_arn = aws_iam_role.tf-codepipeline-role.arn

    artifact_store {
      type = "S3"
      location = aws_s3_bucket.artifacts.id
    }

    # Source Stage
    stage {
      name = "Source"
      action {
          name = "Source"
          version = "1"
          category = "Source"
          owner = "AWS"
          output_artifacts = ["tf-code"]

          provider = "CodeStarSourceConnection"
          configuration = {
            FullRepositoryId = "timsamanchi-PPS/PPS-POC-PIPELINE"
            BranchName = "master"
            ConnectionArn = var.codestar-connector 
            OutputArtifactFormat = "CODE_ZIP"
          }
      }
    }

    # Stage Plan
    stage {
        name = "Plan"
        action {
            name = "Build"
            version = "1"
            category = "Build"
            owner = "AWS"
            input_artifacts = ["tf-code"]

            provider = "CodeBuild"
            configuration = {
              ProjectName = "tf-cicd-plan"
            }
        }
    }

    # Stage Apply
    stage {
        name = "Apply"
        action {
            name = "Build"
            version = "1"
            category = "Build"
            owner = "AWS"
            input_artifacts = ["tf-code"]

            provider = "CodeBuild"
            configuration = {
              ProjectName = "tf-cicd-apply"
            }
        }
    }




}
    # Stage Deploy 
#     stage {
#         name = "Deploy"
#         action {
#             name = "Deploy"
#             version = "1"
#             category = "Deploy"
#             owner = "AWS"
#             input_artifacts = ["tf-code"]

#             provider = "CodeBuild"
#             configuration = {
#               ProjectName = "tf-cicd-apply"
#             }
#         }
#     }
 
