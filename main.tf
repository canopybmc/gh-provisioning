terraform {
  # Tofu version (!)
  required_version = ">= 1.12"

  # State is kept locally for now and is not committed. It moves to GCS once the bucket
  # exists, by uncommenting the block below and running `tofu init -migrate-state`.
  #
  # backend "gcs" {
  #   bucket = "canopybmc-tofu-state"
  #   prefix = "gh-provisioning"
  # }
}
