# Creating or adopting a repository

Every repository in the organisation is described by one `module` block in
`repositories.tf` that uses the `modules/github-repository` module.

## Creating a new repository

Add a new module block to `repositories.tf`. The module name is the repository
name in `snake_case`, as module names can't contain `-` or start with `.`:

```hcl
module "my_new_repo" {
  source                 = "./modules/github-repository"
  repository_name        = "my-new-repo"
  repository_description = "Short description of what this repository is for"
  repository_topics      = ["openbmc", "go"]

  labels = local.common_labels
}
```

`labels` is the only required setting besides the name. Use
`local.common_labels` unless the repository needs more. See
[labels](labels.md).

Everything else falls back to our defaults in
`modules/github-repository/variables.tf`. Notable ones:

| Setting                           | Default             |
| --------------------------------- | ------------------- |
| `visibility`                      | `public`            |
| `default_branch`                  | `main`              |
| Merge methods                     | merge, rebase       |
| `web_commit_signoff_required`     | `true`              |
| `required_approving_review_count` | `1`                 |
| `require_code_owner_review`       | `true`              |
| `protected_branches`              | `~DEFAULT_BRANCH`   |
| Wiki, projects, discussions       | disabled            |

Squash merges are disabled by default on purpose as it drops the
DCO-sign-off trailer and other trailers of all but the first commit.

If the repository should enforce CI, list the check names, as GitHub shows them
on a pull request:

```hcl
  required_status_checks = ["Format", "Validate", "Lint"]
```

The checks have to exist before they can be required. For a brand new
repository, apply it without `required_status_checks` first, push the CI
workflow and add the checks in a follow-up change.

### Private repositories

GitHub free doesn't support rulesets and secret scanning on private repos, so
these have to be disabled explicitly. The validation of the module fails
otherwise.

```hcl
module "my_private_repo" {
  source          = "./modules/github-repository"
  repository_name = "my-private-repo"
  visibility      = "private"
  allow_forking   = false

  manage_rulesets             = false
  enable_secret_scanning      = false
  enable_vulnerability_alerts = false

  labels = local.common_labels
}
```

### Applying

`tofu apply` creates the repository together with its ruleset. The initial
content then has to go in through a pull request like any other change, or be
pushed by an admin, who can bypass the ruleset.

## Adopting an existing repository

A repository that was created through the web UI has to be imported into the
state, otherwise Tofu tries to create it and fails because it already exists.

1. Add the module block as described above. Match the current settings of the
   repository where they differ from our defaults on purpose, and leave the
   rest to the defaults.

2. Add `import` blocks for the resources of the module, e.g. in a temporary
   `imports.tf`:

   ```hcl
   import {
     to = module.my_new_repo.github_repository.repository
     id = "my-new-repo"
   }

   import {
     to = module.my_new_repo.github_branch_default.default
     id = "my-new-repo"
   }

   import {
     to = module.my_new_repo.github_issue_labels.labels
     id = "my-new-repo"
   }

   import {
     to = module.my_new_repo.github_repository_vulnerability_alerts.vulnerability_alerts
     id = "my-new-repo"
   }

   import {
     to = module.my_new_repo.github_repository_dependabot_security_updates.security_updates
     id = "my-new-repo"
   }
   ```

   If the repository already has a ruleset called `protected-branches`, import
   it as well. The ID is `<repository>:<ruleset id>`, the ruleset ID is the
   number at the end of the ruleset URL in the repository settings:

   ```hcl
   import {
     to = module.my_new_repo.github_repository_ruleset.branches[0]
     id = "my-new-repo:1234567"
   }
   ```

   Rulesets with a different name are left alone by Tofu. Delete them by hand
   once the managed ruleset is in place.

3. Run `tofu plan`. It should list the imports and only the changes you expect
   to bring the repository in line with our standard. Pay close attention to
   labels: any existing label that isn't in `labels` gets deleted.

4. Apply, then remove the `import` blocks again in a follow-up change. They are
   no-ops once the resources are in the state.

## Renaming a repository

Changing `repository_name` renames the repository in place, GitHub redirects
the old URL. Renaming the `module` block, however, makes Tofu think it is a
different repository. If you rename the module block, add a `moved` block so
the state follows:

```hcl
moved {
  from = module.old_name
  to   = module.new_name
}
```
