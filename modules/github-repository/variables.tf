variable "repository_name" {
  description = "The name of the repository"
  type        = string
}

variable "repository_description" {
  description = "The description of the repository"
  type        = string
  default     = null
}

variable "repository_homepage" {
  description = "The homepage URL of the repository"
  type        = string
  default     = null
}

variable "repository_topics" {
  description = "The topics of the repository"
  type        = set(string)
  default     = []
}

variable "visibility" {
  description = "The visibility of the repository"
  type        = string
  default     = "public"

  validation {
    condition     = contains(["public", "private"], var.visibility)
    error_message = "visibility must be public or private"
  }
}

variable "default_branch" {
  description = "The default branch of the repository"
  type        = string
  default     = "main"
}

variable "archived" {
  description = "Set to true to archive the repository"
  type        = bool
  default     = false
}

variable "archive_on_destroy" {
  description = "Archive the repository instead of deleting it on destroy"
  type        = bool
  default     = true
}

variable "is_template" {
  description = "Set to true to make the repository a template repository"
  type        = bool
  default     = false
}

variable "enable_issues" {
  description = "Enable issues for the repository"
  type        = bool
  default     = true
}

variable "enable_projects" {
  description = "Enable the projects tab for the repository"
  type        = bool
  default     = false
}

variable "enable_wiki" {
  description = "Enable the wiki for the repository"
  type        = bool
  default     = false
}

variable "enable_discussions" {
  description = "Enable discussions for the repository"
  type        = bool
  default     = false
}

variable "allow_forking" {
  description = "Allow forking of the repository. Has no effect on public repositories, which are always forkable"
  type        = bool
  default     = true
}

variable "allow_merge_commit" {
  description = "Allow merge commits"
  type        = bool
  default     = true
}

variable "allow_rebase_merge" {
  description = "Allow rebase merges"
  type        = bool
  default     = true
}

variable "allow_squash_merge" {
  description = "Allow squash merges. Disabled by default, because squashing drops the trailers of all but the first commit"
  type        = bool
  default     = false
}

variable "allow_auto_merge" {
  description = "Allow pull requests to be queued for auto-merge once all required checks pass"
  type        = bool
  default     = true
}

variable "allow_update_branch" {
  description = "Always suggest updating pull request branches"
  type        = bool
  default     = false
}

variable "delete_branch_on_merge" {
  description = "Delete the branch after a PR got merged"
  type        = bool
  default     = false
}

variable "web_commit_signoff_required" {
  description = "Require a Signed-off-by trailer on commits created through the web interface"
  type        = bool
  default     = true
}

variable "merge_commit_title" {
  description = "The title of merge commits"
  type        = string
  default     = "MERGE_MESSAGE"

  validation {
    condition     = contains(["PR_TITLE", "MERGE_MESSAGE"], var.merge_commit_title)
    error_message = "merge_commit_title must be PR_TITLE or MERGE_MESSAGE"
  }
}

variable "merge_commit_message" {
  description = "The message body of merge commits"
  type        = string
  default     = "PR_TITLE"

  validation {
    condition     = contains(["PR_BODY", "PR_TITLE", "BLANK"], var.merge_commit_message)
    error_message = "merge_commit_message must be PR_BODY, PR_TITLE or BLANK"
  }
}

variable "labels" {
  description = "Issue and pull request labels of the repository, keyed by label name."
  type = map(object({
    color       = string
    description = optional(string, null)
  }))

  validation {
    condition     = alltrue([for label in var.labels : can(regex("^[0-9a-f]{6}$", label.color))])
    error_message = "label colors must be six lowercase hexadecimal digits, without a leading '#'"
  }
}

variable "enable_vulnerability_alerts" {
  description = "Enable Dependabot vulnerability alerts"
  type        = bool
  default     = true
}

variable "enable_dependabot_security_updates" {
  description = "Enable automated Dependabot security update pull requests. Requires enable_vulnerability_alerts"
  type        = bool
  default     = false

  validation {
    condition     = !var.enable_dependabot_security_updates || var.enable_vulnerability_alerts
    error_message = "security updates require vulnerability alerts"
  }
}

variable "enable_secret_scanning" {
  description = <<-EOT
    Enable secret scanning and push protection. Only available for public
    repositories for us.
  EOT
  type        = bool
  default     = true

  validation {
    condition     = !var.enable_secret_scanning || var.visibility == "public"
    error_message = "secret scanning are only available for public repositories (plan restriction)"
  }
}

variable "manage_rulesets" {
  description = <<-EOT
    Manage the branch and tag rulesets of the repository.
    Only available in public for us.
  EOT
  type        = bool
  default     = true

  validation {
    condition     = !var.manage_rulesets || var.visibility == "public"
    error_message = "rulesets are only available for public repositories (plan restriction)"
  }
}

variable "ruleset_enforcement" {
  description = "The enforcement level of the branch ruleset"
  type        = string
  default     = "active"

  validation {
    condition     = contains(["active", "evaluate", "disabled"], var.ruleset_enforcement)
    error_message = "ruleset_enforcement must be active, evaluate or disabled"
  }
}

variable "protected_branches" {
  description = "The branch patterns protected by the branch ruleset"
  type        = list(string)
  default     = ["~DEFAULT_BRANCH"]
}

variable "required_approving_review_count" {
  description = "The number of approving reviews required before a pull request can be merged"
  type        = number
  default     = 1
}

variable "require_code_owner_review" {
  description = "Require a review from a code owner when a pull request touches owned files"
  type        = bool
  default     = true
}

variable "dismiss_stale_reviews_on_push" {
  description = "Dismiss approving reviews when new commits are pushed to the pull request"
  type        = bool
  default     = true
}

variable "require_last_push_approval" {
  description = "Require an approval from somebody other than the author of the most recent push"
  type        = bool
  default     = false
}

variable "required_review_thread_resolution" {
  description = "Require all review conversations to be resolved before merging"
  type        = bool
  default     = true
}

variable "required_linear_history" {
  description = "Prevent merge commits from being pushed to the protected branches"
  type        = bool
  default     = false
}

variable "required_signatures" {
  description = "Require all commits on the protected branches to be signed"
  type        = bool
  default     = false
}

variable "required_status_checks" {
  description = "The status checks that have to pass before a pull request can be merged"
  type        = list(string)
  default     = []
}

variable "strict_required_status_checks_policy" {
  description = "Require the pull request branch to be up to date with the base branch before merging"
  type        = bool
  default     = false
}

variable "ruleset_bypass_actors" {
  type = list(object({
    actor_id    = optional(number)
    actor_type  = string
    bypass_mode = optional(string, "always")
  }))
  default = [{
    actor_id   = 5
    actor_type = "RepositoryRole"
  }]
}
