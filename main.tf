terraform {
    backend "s3" {
        bucket = "pps-poc-cicd-remote-tfstate-backend-ts"
        key = "global/codepipeline/terraform.tfstate"
        region = "eu-west-2"
        dynamodb_table = "pps-poc-cicd-tfstate-locking-table-ts"
        encrypt = true
    }
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 4.0"
        }
    }
}
provider "aws" {
    region = "eu-west-2"
}