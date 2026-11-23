# Settings not managed by Tofu

This project can't manage some settings, because neither the GitHub provider
nor the GitHub API supports them. An organisation admin has to set them in the
web UI. `tofu plan` doesn't detect drift on them.

## Private vulnerability reporting

Repository: `canopybmc`

In the repository settings, open Advanced Security and click "Settings" next
to Private vulnerability reporting. Set:

- Private vulnerability reporting: enabled
- Require a CWE assignment: enabled
- Daily report limit: 10, which is the GitHub default

Tofu can't manage this for two reasons:

- The GitHub API can only enable or disable private vulnerability reporting,
  using `/repos/{owner}/{repo}/private-vulnerability-reporting`. GitHub added
  the CWE requirement and the daily limit on 2026-10-01 without API endpoints,
  so only the web UI can change them.
- The `integrations/github` provider doesn't support private vulnerability
  reporting at all, not even the on/off switch. The provider maintainers
  closed the feature request
  [#2399](https://github.com/integrations/terraform-provider-github/issues/2399)
  as stale. The latest provider release, 6.13.0, also predates the new
  settings.

Once the API and the provider support these settings, move them into the
module and remove this section.
