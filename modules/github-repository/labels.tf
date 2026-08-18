resource "github_issue_labels" "labels" {
  repository = github_repository.repository.name

  dynamic "label" {
    for_each = var.labels
    content {
      name        = label.key
      color       = label.value.color
      description = label.value.description
    }
  }
}
