<!-- BEGIN_TF_DOCS -->
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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_approvals_required"></a> [approvals\_required](#input\_approvals\_required) | The minimum number of approvals required for MRs | `number` | `1` | no |
| <a name="input_author_email_regex"></a> [author\_email\_regex](#input\_author\_email\_regex) | All commit author emails must match this regex | `string` | `null` | no |
| <a name="input_container_registry_enabled"></a> [container\_registry\_enabled](#input\_container\_registry\_enabled) | Enable container registry for the project | `bool` | `true` | no |
| <a name="input_default_branch"></a> [default\_branch](#input\_default\_branch) | The default branch for the project | `string` | `"master"` | no |
| <a name="input_description"></a> [description](#input\_description) | A short description of the project | `string` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | Name of the project | `string` | n/a | yes |
| <a name="input_namespace_id"></a> [namespace\_id](#input\_namespace\_id) | The group where the project belongs to | `string` | n/a | yes |
| <a name="input_owners"></a> [owners](#input\_owners) | A list of specific User IDs allowed to approve Merge Requests. Please refer to [Gitlab documentation](https://docs.gitlab.com/ee/user/project/merge_requests/approvals/index.html) for further information | `list(string)` | `[]` | no |
| <a name="input_pipelines_enabled"></a> [pipelines\_enabled](#input\_pipelines\_enabled) | Enable pipelines for the project | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | The list of tags to be attached to the project | `list(string)` | `[]` | no |
| <a name="input_template_project_id"></a> [template\_project\_id](#input\_template\_project\_id) | Project ID of a custom project template. Please refer to [Gitlab documentation](https://docs.gitlab.com/ee/user/group/custom_project_templates.html) for further information | `number` | `null` | no |
| <a name="input_use_custom_template"></a> [use\_custom\_template](#input\_use\_custom\_template) | Use either custom instance or group project template | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | Integer that uniquely identifies the project within the gitlab install |
| <a name="output_path_with_namespace"></a> [path\_with\_namespace](#output\_path\_with\_namespace) | The path of the repository with namespace |
| <a name="output_web_url"></a> [web\_url](#output\_web\_url) | URL that can be used to find the project in a browser |

That's it! Run `terraform plan` and check the output to see if matches your recent changes.

## Contributing
Checkout our [contributing](/CONTRIBUTING.md) guide.

## References
* [gitlab\_project resource in GitLab Provider](https://registry.terraform.io/providers/gitlabhq/gitlab/latest/docs/resources/project)
* [Input Variables in Terraform](https://www.terraform.io/docs/language/values/variables.html)
<!-- END_TF_DOCS -->