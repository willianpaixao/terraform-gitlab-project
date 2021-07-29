output "id" {
  value       = gitlab_project.default.id
  description = "Integer that uniquely identifies the project within the gitlab install"
}

output "path_with_namespace" {
  value       = gitlab_project.default.path_with_namespace
  description = "The path of the repository with namespace"
}

output "web_url" {
  value       = gitlab_project.default.web_url
  description = "URL that can be used to find the project in a browser"
}
