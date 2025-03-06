terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 5.0"
    }
  }
}

provider "github" {
  token = var.github_token
}

resource "github_repository" "repo" {
  name        = "my-repo"
  description = "Terraform managed repository"
  visibility  = "private"
  auto_init   = true
  has_issues  = true
}

resource "github_repository_collaborator" "collab" {
  repository = github_repository.repo.name
  username   = "softservedata"
  permission = "push"
}

resource "github_branch" "develop" {
  repository = github_repository.repo.name
  branch     = "develop"
}

resource "github_branch_default" "default" {
  repository = github_repository.repo.name
  branch     = github_branch.develop.branch
}

resource "github_repository_file" "pull_request_template" {
  repository = github_repository.repo.name
  file       = ".github/pull_request_template.md"
  content    = <<EOT
## Describe your changes

## Issue ticket number and link

## Checklist before requesting a review
- [ ] I have performed a self-review of my code
- [ ] If it is a core feature, I have added thorough tests
- [ ] Do we need to implement analytics?
- [ ] Will this be part of a product update? If yes, please write one phrase about this update
EOT
}

resource "github_repository_deploy_key" "deploy_key" {
  repository = github_repository.repo.name
  title      = "DEPLOY_KEY"
  key        = var.deploy_key
  read_only  = false
}

variable "github_token" {}
variable "deploy_key" {}
