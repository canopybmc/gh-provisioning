module "canopybmc" {
  source                 = "./modules/github-repository"
  repository_name        = "canopybmc"
  repository_description = "An upstream-first OpenBMC distribution focused on Stability, Long-Term Maintenance, Testing, and Developer Enablement."
  repository_homepage    = "https://canopybmc.org"
  repository_topics      = ["openbmc", "bmc", "firmware", "yocto", "openembedded"]
  enable_discussions     = true
  enable_projects        = true

  labels = merge(local.common_labels, local.canopybmc_labels, local.release_labels)
}

module "website" {
  source                 = "./modules/github-repository"
  repository_name        = "website"
  repository_description = "canopybmc.org website"
  repository_homepage    = "https://canopybmc.org"
  repository_topics      = ["website"]
  enable_projects        = true

  labels = local.common_labels
}

module "osfci_cli" {
  source                 = "./modules/github-repository"
  repository_name        = "osfci-cli"
  repository_description = "Command line interface for the Open Source Firmware CI"
  repository_topics      = ["osfci", "cli", "go"]
  enable_projects        = true

  labels = local.common_labels
}

module "dot_github" {
  source                 = "./modules/github-repository"
  repository_name        = ".github"
  repository_description = "CanopyBMC organisation repository"

  required_approving_review_count = 1

  labels = local.common_labels
}

module "management" {
  source                 = "./modules/github-repository"
  repository_name        = "management"
  repository_description = "Internal organisation management"
  visibility             = "private"
  enable_projects        = true
  allow_forking          = false

  manage_rulesets             = false
  enable_secret_scanning      = false
  enable_vulnerability_alerts = false

  labels = merge(local.common_labels, {
    "customer" = {
      color       = "56d54f"
      description = "Customer related"
    }
    "action item" = {
      color       = "0022dd"
      description = "Action from a meeting or a call"
    }
  })
}
