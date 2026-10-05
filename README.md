# Provisioning

This project provisions and standardises the GitHub repositories, labels
and team settings of the [canopybmc](https://github.com/canopybmc)
organisation using [OpenTofu](https://opentofu.org).

Instead of clicking through the GitHub web UI, every setting is described in
code, reviewed in a pull request and then applied. This keeps the repositories
consistent with each other and makes manual drift visible.

The Tofu state is meant to live in a GCS bucket. For now it is only stored
locally for internal reasons, see `main.tf`.

> [!NOTE]
> This project can only be applied and ran by 9elements employees that have
> admin privileges on the canopybmc organisation!
> For 9e employees, contact the Canopy team via chat. For external
> contributors, consider opening an issue and describe what you'd like to be
> changed.

## Structure

| File                           | Contents                                                               |
| ------------------------------ | ---------------------------------------------------------------------- |
| `repositories.tf`              | One `module` block per repository                                      |
| `labels.tf`                    | Label sets, primarily for CanopyBMC                                    |
| `teams.tf`                     | GitHub Team settings                                                   |
| `modules/github-repository/`   | Abstraction for a GitHub repo. Could be replaced with another provider |
| `provider.tf`, `main.tf`       | Provider, Tofu version and state backend                               |

In the repo module block we manage repository settings, issue and pr labels,
protected branches, dependabot and secret scanning rules.

All available settings and their defaults are documented in
[`modules/github-repository/variables.tf`](modules/github-repository/variables.tf).
The defaults are our standard, so a repository should only override what it
really needs to.

> [!WARNING]
> Labels are managed authoritatively, meaning if label that exists on GitHub but
> not in Tofu, then it gets deleted on the next apply, and with it its
> assignment on every issue and pull request. Repositories that are removed
> from the code are archived and not deleted.

## Requirements

- **OpenTofu** version >= 1.12
- A GitHub token with admin access on the canopybmc organisation

## Usage

### Making a change

1. Create a branch and edit the `.tf` files. The
   [Documentation](#documentation) covers the common cases.
2. Format and validate locally:

   ```sh
   tofu fmt -recursive
   tofu init -backend=false
   tofu validate
   tflint --init && tflint --recursive
   ```

3. If you have admin access, run `tofu plan` (see below) and paste the
   relevant part of the plan into the pull request description.
4. Open a pull request. It needs an approval from
   `@canopybmc/canopy-management` (see `.github/CODEOWNERS`).

### Applying a change

Changes are applied by an organisation admin after the pull request got merged,
from an up to date `main`:

```sh
git switch main && git pull
export GITHUB_TOKEN="$(gh auth token)"
tofu init
tofu plan -out=tfplan
tofu apply tfplan
```

Always read the plan before applying it. In particular, look out for:

- Labels being destroyed, as they are removed from all issues and pull
  requests
- Repositories being archived or replaced
- Rulesets being loosened

As long as the state is stored locally, only one person can apply changes.
Coordinate with the Canopy team before running `tofu apply` from another
machine.

### Drift

Running `tofu plan` on an unchanged `main` should report no changes. If it
does, somebody changed a setting through the web UI or the API. Either revert
it with `tofu apply`, or, if the change was intended, put it into code via a
pull request.

## Documentation

- [Creating or adopting a repository](Documentation/new-repository.md)
- [Archiving a repository](Documentation/archive-repository.md)
- [Adding a new CanopyBMC release](Documentation/new-release.md)
- [Adding a new vendor or target](Documentation/new-target.md)
- [Adding, changing or removing labels](Documentation/labels.md)
- [Managing team settings](Documentation/teams.md)
