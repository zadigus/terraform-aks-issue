locals {
  resource_group_name = format(
    "%s_spoke_rg",
    var.group_prefix,
  )
}