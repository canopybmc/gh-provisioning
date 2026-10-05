# Adding a new CanopyBMC release

Release and backport labels of the `canopybmc` repository are generated from
`local.supported_releases` in `labels.tf`:

```hcl
supported_releases = {
  "2026.06" = {
    lts       = false
    backports = false
  }
}
```

For every release, the following labels are created:

| Label               | Created when       | Purpose                                  |
| ------------------- | ------------------ | ---------------------------------------- |
| `release/<version>` | always             | Issue or PR affects this release         |
| `backport/<version>`| `backports = true` | Pick this PR into the release branch     |

`release/rolling`, `backport/needed` and `backport/automated` always exist and
don't depend on the list.

## Adding a release

Add an entry with the version as key:

```hcl
supported_releases = {
  "2026.06" = {
    lts       = false
    backports = false
  }
  "2026.12" = {
    lts       = true
    backports = true
  }
}
```

- `lts` only changes the label description, from "stable" to "LTS".
- `backports` creates the `backport/<version>` label. Enable it for as long
  as fixes are picked into the release branch.

Run `tofu plan`, it should only show the new labels being added to
`module.canopybmc.github_issue_labels.labels`.

If the release branch should be protected by the ruleset as well, add its name
or pattern to `protected_branches` of the `canopybmc` module, keeping the
default branch in the list:

```hcl
  protected_branches = ["~DEFAULT_BRANCH", "refs/heads/2026.12"]
```

## Ending backports for a release

Set `backports = false`. This deletes the `backport/<version>` label, and
removes it from all pull requests that still carry it. Make sure there are no
open backport pull requests left before applying.

## Dropping a release

Removing the entry deletes the `release/<version>` label, and with it the
label assignment on every issue and pull request. That history is lost, so
only drop a release once nobody needs to search by it anymore. Until then,
keeping an end of life release in the list with `backports = false` is
cheap.
