locals {
  log_analytics_workspace_name = format(
    "%s-%s-%s",
    var.name_prefix,
    var.log_analytics_workspace_name,
    var.name_suffix,
  )
}