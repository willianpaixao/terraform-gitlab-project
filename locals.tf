locals {
  author_email_regex = var.author_email_regex
  description        = chomp(var.description)
  name               = lower(var.name)
  tags               = ["terraform"]
}
