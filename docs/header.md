# Gitlab project Terraform module

To create a new Gitlab [project](https://docs.gitlab.com/ee/user/project/) (aka Git repository) under an existing [group](https://docs.gitlab.com/ee/user/group/), this module is a handy shortcut.
It reduces the boilerplate and has better security flags raised by default.

-> The group can be created or imported using [gitlab_group](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group)

## Default resources and features

| Feature | Default |
|---------|:-------:|
| [CI/CD Pipelines](https://docs.gitlab.com/ee/ci/pipelines/) | `true` |
| [Container Registry](https://docs.gitlab.com/ee/user/packages/container_registry/) | `true` |
| [Git Large File Storage (LFS)](https://docs.gitlab.com/ee/topics/git/lfs/) | `false` |
| [Gitlab Pages](https://docs.gitlab.com/ee/user/project/pages/) | `false` |
| [Issues](https://docs.gitlab.com/ee/user/project/issues/) | `false` |
| [Package Registry](https://docs.gitlab.com/ee/user/packages/package_registry/) | `false` |
| [Snippets](https://docs.gitlab.com/ee/user/snippets.html) | `false` |
| [Wiki](https://docs.gitlab.com/ee/user/project/wiki/) | `false` |

## Examples

### Create one repository

Pretty simple, add the following block and replace the values accordingly.

```hcl
module "project" {
  source  = "willianpaixao/project/gitlab"
  version = "~> 1.0.1"

  name         = "My New Pet project"
  description  = "Yet another project I will never finish"
  namespace_id = gitlab_group.some-group.id
  tags         = ["pet", "unfinished"]
}
```

### Create many repositories under the same [subgroup](https://docs.gitlab.com/ee/user/group/subgroups/)

The usage consists of two simple steps, first define your variable in `variables.tf` then add the `module` block to your code, referencing the `source` as following:

```hcl
variable "project" {
  description = "list of attributes of a project"
  type        = map(any)
  default = {
    your-shiny-project = {
      name        = "your-shiny-project"
      description = "A descriptive description"
      tags        = ["tagA", "tagB"]
  }
}

module "subgroup_projects" {
  source  = "willianpaixao/project/gitlab"
  version = "~> 1.0.1"

  for_each = var.project

  name         = each.value.name
  description  = each.value.description
  namespace_id = gitlab_group.some-group.id
  tags         = setunion(["subgroup"], each.value.tags)
}
```

### Setting a list of project owners
```hcl
data "gitlab_user" "owners" {
  for_each = toset(["user1", "user2", "user3"])
  username = each.value
}

module "api" {
  source  = "willianpaixao/project/gitlab"
  version = "~> 1.0.1"

  name               = "api"
  description        = "REST API"
  namespace_id       = gitlab_group.some-group.id
  approvals_required = 3
  owners             = [for user in data.owners.users : user.id]
  tags               = "api"
}

resource "gitlab_project_membership" "owners" {
  for_each     = [for user in data.owners.users : user.id]
  project_id   = module.api.id
  user_id      = each.key
  access_level = "owners"
}
```

That's it! Run `terraform plan` and check the output to see if matches your recent changes.
