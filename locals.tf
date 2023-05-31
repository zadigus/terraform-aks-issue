locals {
  aks_name        = join("-", [var.project_name, var.jira_project_id])
  resource_prefix = lower(replace(var.project_name, "/\\W|_|\\s/", ""))
  resource_suffix = lower(replace(var.jira_project_id, "/\\W|_|\\s/", ""))
  environment     = "dev"
  tags            = {
    "monitoring"  = "true"
    "Owner"       = "MDL"
    "Env_Name"    = local.environment
    "Project_Name" = var.project_name
  }

  aks_network = {
    "vnet" : var.aks_vnet
    "workers_subnet" : cidrsubnet(var.aks_vnet, 2, 0)
  }
}