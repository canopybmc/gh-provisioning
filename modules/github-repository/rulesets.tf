resource "github_repository_ruleset" "branches" {
  count = var.manage_rulesets ? 1 : 0

  name        = "protected-branches"
  repository  = github_repository.repository.name
  target      = "branch"
  enforcement = var.ruleset_enforcement

  conditions {
    ref_name {
      include = var.protected_branches
      exclude = []
    }
  }

  rules {
    deletion                = var.delete_branch_on_merge
    non_fast_forward        = true
    required_linear_history = var.required_linear_history
    required_signatures     = var.required_signatures

    pull_request {
      required_approving_review_count   = var.required_approving_review_count
      require_code_owner_review         = var.require_code_owner_review
      dismiss_stale_reviews_on_push     = var.dismiss_stale_reviews_on_push
      require_last_push_approval        = var.require_last_push_approval
      required_review_thread_resolution = var.required_review_thread_resolution
      allowed_merge_methods = compact([
        var.allow_merge_commit ? "merge" : "",
        var.allow_rebase_merge ? "rebase" : "",
        var.allow_squash_merge ? "squash" : "",
      ])
    }

    dynamic "required_status_checks" {
      for_each = length(var.required_status_checks) > 0 ? [1] : []
      content {
        strict_required_status_checks_policy = var.strict_required_status_checks_policy

        dynamic "required_check" {
          for_each = var.required_status_checks
          content {
            context = required_check.value
          }
        }
      }
    }
  }

  dynamic "bypass_actors" {
    for_each = var.ruleset_bypass_actors
    content {
      actor_id    = bypass_actors.value.actor_id
      actor_type  = bypass_actors.value.actor_type
      bypass_mode = bypass_actors.value.bypass_mode
    }
  }
}
