# Archiving a repository

To archive a repository but keep managing it, set `archived` in its module
block:

```hcl
module "old_repo" {
  source          = "./modules/github-repository"
  repository_name = "old-repo"
  archived        = true

  labels = local.common_labels
}
```

An archived repository is read only. GitHub rejects most changes to it, so
change its settings before archiving it, not afterwards. To change something
later, unarchive it first by setting `archived = false` and apply.

## Removing a repository from the code

Removing the module block from `repositories.tf` doesn't delete the repository
as we set `archive_on_destroy` by default to `true`.

If a repository must really be deleted, set `archive_on_destroy = false`,
apply, and only then remove the module block. Deleting a repository can't be
undone, so double check with the Canopy team first. Alternatively, keep it as is
and remove it afterwards via the GitHub Web UI.

To stop managing a repository without archiving it, remove it from the state
instead, using a `removed` block in place of the module block:

```hcl
removed {
  from = module.old_repo

  lifecycle {
    destroy = false
  }
}
```

Apply, then remove the `removed` block in a follow-up change.
