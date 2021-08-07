<!-- BEGIN_TF_DOCS -->
![GitLab Logo](https://about.gitlab.com/images/press/logo/png/gitlab-logo-gray-rgb.png)

# Gitlab project Terraform module

This module is built upon the [gitlabhq/gitlab](https://github.com/gitlabhq/terraform-provider-gitlab) provider, and is used to create a new Gitlab [projects](https://docs.gitlab.com/ee/user/project/) (aka Git repository) under an existing [group](https://docs.gitlab.com/ee/user/group/).
It reduces the boilerplate and has better security flags raised by default.

-> The group can be created or imported using [gitlab\_group](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/group)

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

## Providers

| Name | Version |
|------|---------|
| <a name="provider_gitlab"></a> [gitlab](#provider\_gitlab) | >= 3.7.0 |

## Resources

| Name | Type |
|------|------|
| [gitlab_branch_protection.default](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/branch_protection) | resource |
| [gitlab_pipeline_trigger.default](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/pipeline_trigger) | resource |
| [gitlab_project.default](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project) | resource |
| [gitlab_project_approval_rule.default](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project_approval_rule) | resource |
| [gitlab_project_level_mr_approvals.default](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project_level_mr_approvals) | resource |
| [gitlab_tag_protection.default](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/tag_protection) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_description"></a> [description](#input\_description) | A short description of the project | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_namespace_id"></a> [namespace\_id](#input\_namespace\_id) | The group where the project belongs to | `string` | n/a | yes |
| <a name="input_approvals_required"></a> [approvals\_required](#input\_approvals\_required) | The minimum number of approvals required for MRs | `number` | `1` | no |
| <a name="input_author_email_regex"></a> [author\_email\_regex](#input\_author\_email\_regex) | All commit author emails must match this regex. As part of [Push Rules](https://docs.gitlab.com/ee/push_rules/push_rules.html), it's only available for GitLab Premium | `string` | `null` | no |
| <a name="input_container_registry_enabled"></a> [container\_registry\_enabled](#input\_container\_registry\_enabled) | Enable container registry for the project | `bool` | `true` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | The default branch for the project | `string` | `"main"` | no |
| <a name="input_owners"></a> [owners](#input\_owners) | A list of specific User IDs allowed to approve Merge Requests. Please refer to [Gitlab documentation](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/index.html) for further information | `list(string)` | `[]` | no |
| <a name="input_pipelines_enabled"></a> [pipelines\_enabled](#input\_pipelines\_enabled) | Enable pipelines for the project | `bool` | `true` | no |
| <a name="input_shared_runners_enabled"></a> [shared\_runners\_enabled](#input\_shared\_runners\_enabled) | Enable [shared runners](https://docs.gitlab.com/ee/ci/runners/) for the project | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The list of tags to be attached to the project | `list(string)` | `[]` | no |
| <a name="input_template_project_id"></a> [template\_project\_id](#input\_template\_project\_id) | Project ID of a custom project template. Please refer to [Gitlab documentation](https://docs.gitlab.com/ee/user/group/custom_project_templates.html) for further information | `number` | `null` | no |
| <a name="input_use_custom_template"></a> [use\_custom\_template](#input\_use\_custom\_template) | Use either custom instance or group-level project template | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Integer that uniquely identifies the project within the gitlab install |
| <a name="output_path_with_namespace"></a> [path\_with\_namespace](#output\_path\_with\_namespace) | The path of the repository with namespace |
| <a name="output_web_url"></a> [web\_url](#output\_web\_url) | URL that can be used to find the project in a browser |

## Changelog

Please refer to our [changelog](/CHANGELOG.md) for further information on versioning and upgrades.

## Contributing

Checkout our [contributing](/CONTRIBUTING.md) guide.

## References

* [gitlab\_project resource in GitLab Provider](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project)

* [Input Variables in Terraform](https://www.terraform.io/docs/language/values/variables.html)
<!-- END_TF_DOCS -->