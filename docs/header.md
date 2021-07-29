# Gitlab project Terraform module

To create a new Gitlab [project](https://docs.gitlab.com/ee/user/project/) (aka Git repository) under an existing [group](https://docs.gitlab.com/ee/user/group/), this module is a handy shortcut.
It reduces the boilerplate and has better security flags raised by default.

## Default resources and features

| Feature | Default |
|---------|:-------:|
| [CI/CD Pipelines](https://docs.gitlab.com/ee/ci/pipelines/) | `true` |
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
module "my_new_repo" {
  source = "./modules/gitlab/project"

  name         = "My New Pet project"
  description  = "Yet another project I will never finish"
  namespace_id = gitlab_group.some-group.id
  tags         = ["pet", "unfinished"]
}
```

### Create many repositories under the same [subgroup](https://docs.gitlab.com/ee/user/group/subgroups/).
The usage consists of two simple steps, first define your variable in `variables.tf` then add the `module` block to your code, referencing the `source` as following:

```hcl
# file: variables.tf
variable "project" {
  description = "list of attributes of a project"
  type        = map(any)
  default = {
    eth-collector = {
      name        = "your-shiny-project"
      description = "A descriptive description"
      tags        = ["tagA", "tagB"]
  }
}

# file: main.tf
module "subgroup_projects" {
  source = "./modules/gitlab/project"

  for_each = var.project

  name         = each.value.name
  description  = each.value.description
  namespace_id = gitlab_group.some-group.id
  tags         = setunion(["subgroup"], each.value.tags)
}
```
