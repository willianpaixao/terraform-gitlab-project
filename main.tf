terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">= 3.7.0"
    }
  }
}

resource "gitlab_project" "default" {
  name           = local.name
  description    = local.description
  namespace_id   = var.namespace_id
  default_branch = var.default_branch

  container_registry_enabled = var.container_registry_enabled
  issues_enabled             = false
  lfs_enabled                = false
  packages_enabled           = false
  pipelines_enabled          = var.pipelines_enabled
  request_access_enabled     = false
  shared_runners_enabled     = false
  snippets_enabled           = false
  wiki_enabled               = false

  group_with_project_templates_id = var.namespace_id
  template_project_id             = var.template_project_id
  use_custom_template             = var.use_custom_template

  only_allow_merge_if_all_discussions_are_resolved = true
  only_allow_merge_if_pipeline_succeeds            = true
  remove_source_branch_after_merge                 = true

  push_rules {
    author_email_regex     = local.author_email_regex
    commit_committer_check = true
    member_check           = true
    prevent_secrets        = true
  }

  tags = setunion(local.tags, compact(var.tags))

  lifecycle {
    prevent_destroy = true
  }
}

resource "gitlab_branch_protection" "default" {
  project            = gitlab_project.default.id
  branch             = var.default_branch
  push_access_level  = "developer"
  merge_access_level = "developer"
}

resource "gitlab_project_approval_rule" "default" {
  project            = gitlab_project.default.id
  name               = "Minimum one approval required"
  approvals_required = var.approvals_required
  user_ids           = compact(var.owners)
}

resource "gitlab_project_level_mr_approvals" "default" {
  project_id                                 = gitlab_project.default.id
  merge_requests_author_approval             = false
  merge_requests_disable_committers_approval = true
  reset_approvals_on_push                    = true
}

resource "gitlab_pipeline_trigger" "default" {
  project     = gitlab_project.default.id
  description = "Used to trigger builds in bulk"
}
