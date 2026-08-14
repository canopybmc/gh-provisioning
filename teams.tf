locals {
  team_review_defaults = {
    delegate       = true
    algorithm      = "LOAD_BALANCE"
    reviewer_count = 1
    notify         = false
  }

  teams = {
    "9e-developers" = {}
    "9e-restricted" = {
      delegate = false
    }
    "blindspot-developers" = {}
    "canopy-management"    = {}
  }

  team_review_settings = {
    for slug, settings in local.teams :
    slug => merge(local.team_review_defaults, settings)
  }
}

resource "github_team_settings" "teams" {
  for_each = local.team_review_settings

  team_id = each.key
  notify  = each.value.notify

  dynamic "review_request_delegation" {
    for_each = each.value.delegate ? [each.value] : []
    content {
      algorithm    = review_request_delegation.value.algorithm
      member_count = review_request_delegation.value.reviewer_count
    }
  }
}
