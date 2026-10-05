# Adding, changing or removing labels

All labels are declared in `labels.tf` as maps from label name to colour and
description.

| Set                   | Used by                    | Contents                                   |
| --------------------- | -------------------------- | ------------------------------------------ |
| `common_labels`       | every repository           | type, triage, docs, security, Dependabot   |
| `canopybmc_labels`    | `canopybmc`                | targets, upstream, topics, backports       |
| `release_labels`      | `canopybmc`                | generated from `supported_releases`        |

Each repository picks its sets via `labels` in `repositories.tf`.

The labels of a repository are managed authoritatively, meaning only the labels
that are in `labels` will be on GitHub after an apply. Labels created through
the web UI get deleted again.

## Adding a label

Add it to the set it belongs to, next to the labels with the same prefix:

```hcl
    "topic/firmware-update" = {
      color       = "1d76db"
      description = "Firmware update and code update flow"
    }
```

- Use the existing prefixes (`type/`, `topic/`, `triage/`, `target/`,
  `upstream/`, `release/`, `backport/`) where they fit, and reuse the colour
  of the other labels with the same prefix.
- Colours are six lowercase hex digits without a leading `#`.
- Keep the description short, it shows up in the label picker.

`dependencies` and `github_actions` are the labels that bots put on PR. Do not
rename or remove them.

### Labels for a single repository

Merge them into the label sets in `repositories.tf`, like the `management`
repository does:

```hcl
  labels = merge(local.common_labels, {
    "customer" = {
      color       = "56d54f"
      description = "Customer related"
    }
  })
```

If a label is needed by more than one repository, move it into a set in
`labels.tf` instead.

## Changing colour or description

Edit the entry and apply. The label stays attached to its issues and pull
requests.

## Renaming a label

Renaming the key in the code makes Tofu delete the old label and create a new
one, which removes the label from every issue and pull request. To keep the
assignments:

1. Rename the label in the GitHub web UI of every repository that has it.
2. Rename it in the code accordingly.
3. Run `tofu plan`, it should show no label changes.

## Removing a label

Remove the entry and apply. The label is deleted, together with its
assignment on all issues and pull requests. If the label may still be useful
for searching old issues, keep it.
