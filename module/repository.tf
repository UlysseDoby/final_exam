resource "github_repository" "example" {
  name        = "example"
  description = "My awesome codebase"

  visibility = "public"

  template {
    owner      = "github"
    repository = "terraform-module-template"
  }
}