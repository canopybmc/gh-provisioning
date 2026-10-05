# Managing team settings

`teams.tf` manages the code review settings of the organisation teams. It
doesn't create teams or manage their members, that is still done through the
GitHub web UI.

By default, a review request to a team is delegated to one team member, picked
by load balancing, and the rest of the team isn't notified:

```hcl
team_review_defaults = {
  delegate       = true
  algorithm      = "LOAD_BALANCE"
  reviewer_count = 1
  notify         = false
}
```

## Adding a team

1. Create the team in the GitHub web UI.
2. Add its slug to `local.teams`, overriding the defaults where needed:

   ```hcl
   teams = {
     "9e-developers"  = {}
     "my-new-team"    = {
       reviewer_count = 2
     }
   }
   ```

3. Apply. `github_team_settings` doesn't need an import, it only updates the
   settings of a team that already exists.

## Options

| Option           | Values                        | Meaning                                       |
| ---------------- | ----------------------------- | --------------------------------------------- |
| `delegate`       | `true`, `false`               | Assign review requests to individual members  |
| `algorithm`      | `LOAD_BALANCE`, `ROUND_ROBIN` | How the members are picked                    |
| `reviewer_count` | number                        | How many members are picked                   |
| `notify`         | `true`, `false`               | Also notify the whole team                    |

`algorithm` and `reviewer_count` only have an effect with `delegate = true`.

## Removing a team

Remove it from `local.teams` before deleting the team on GitHub, otherwise the
next plan fails because the team can't be found.
