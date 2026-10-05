# Adding a new vendor or target

Target labels mark the platforms an issue or pull request affects. They only
exist in the `canopybmc` repository and are part of `local.canopybmc_labels`
in `labels.tf`.

## Naming

| Label                     | Meaning                              |
| ------------------------- | ------------------------------------ |
| `target/all`              | Affects every supported platform     |
| `target/<vendor>/all`     | Affects every platform of a vendor   |
| `target/<platform>`       | Affects one platform                 |

`<vendor>` and `<platform>` are lowercase, with words separated by `-`. Use
the name that people know the platform by, prefixed by the vendor where the
vendor is part of the product name, e.g. `target/hpe-proliant-g11`.

All target labels use the colour `c5def5`.

## Adding a vendor

Add a `target/<vendor>/all` label together with the first platform of that
vendor. Keep the labels of one vendor next to each other, separated from the
other vendors by an empty line:

```hcl
    "target/acme/all" = {
      color       = "c5def5"
      description = "Affects every ACME platform"
    }
    "target/acme-x100" = {
      color       = "c5def5"
      description = "Affects the ACME X100 platform"
    }
```

## Adding a platform of an existing vendor

Add a `target/<platform>` label below the `target/<vendor>/all` label of the
vendor:

```hcl
    "target/hpe-proliant-g12" = {
      color       = "c5def5"
      description = "Affects HPE ProLiant Gen12 platforms"
    }
```

## Applying

`tofu plan` should only show labels being added to
`module.canopybmc.github_issue_labels.labels`.

If the platform is dropped later, removing its label also removes it from all
issues and pull requests. See [labels](labels.md#removing-a-label).
