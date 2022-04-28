variable "artifacts-bucket" {
    description = "codebuild artifacts s3 bucket"
    type = string
}

variable "dockerHub-credentials" {
    description = "dockerHub credentials to pull down terraform image"
    type = string
}

variable "codestar-connector" {
    description = "connector to gitHub master repository"
    type = string
}