resource "github_repository" "repository" {
  name         = var.repository_name
  description  = var.repository_description
  homepage_url = var.repository_homepage
  topics       = var.repository_topics
  visibility   = var.visibility

  archived           = var.archived
  archive_on_destroy = var.archive_on_destroy
  is_template        = var.is_template

  has_issues      = var.enable_issues
  has_projects    = var.enable_projects
  has_wiki        = var.enable_wiki
  has_discussions = var.enable_discussions
  allow_forking   = var.allow_forking

  allow_merge_commit     = var.allow_merge_commit
  allow_rebase_merge     = var.allow_rebase_merge
  allow_squash_merge     = var.allow_squash_merge
  allow_auto_merge       = var.allow_auto_merge
  allow_update_branch    = var.allow_update_branch
  delete_branch_on_merge = var.delete_branch_on_merge

  merge_commit_title   = var.merge_commit_title
  merge_commit_message = var.merge_commit_message

  web_commit_signoff_required = var.web_commit_signoff_required

  dynamic "security_and_analysis" {
    for_each = var.visibility == "public" ? [var.enable_secret_scanning] : []
    content {
      secret_scanning {
        status = security_and_analysis.value ? "enabled" : "disabled"
      }
      secret_scanning_push_protection {
        status = security_and_analysis.value ? "enabled" : "disabled"
      }
    }
  }

  lifecycle {
    ignore_changes = [auto_init, gitignore_template, license_template, template]
  }
}

resource "github_branch_default" "default" {
  repository = github_repository.repository.name
  branch     = var.default_branch
}

resource "github_repository_vulnerability_alerts" "vulnerability_alerts" {
  repository = github_repository.repository.name
  enabled    = var.enable_vulnerability_alerts
}

resource "github_repository_dependabot_security_updates" "security_updates" {
  repository = github_repository.repository.name
  enabled    = var.enable_vulnerability_alerts && var.enable_dependabot_security_updates

  # Security updates are rejected by the API while alerts are still off.
  depends_on = [github_repository_vulnerability_alerts.vulnerability_alerts]
}
