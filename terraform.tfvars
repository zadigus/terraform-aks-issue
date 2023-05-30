###########################################################
#  Common Configurations
###########################################################
location = "eastus"

###########################################################
#  Kubernetes Clusters Configurations
###########################################################
enable_log_analytics = false
aks_sku_tier         = "Standard"

###########################################################
#  Kubernetes Clusters GPU Node Pool Configurations
###########################################################
aks_cpu_node_pool_vm_size = "Standard_D8ads_v5"

add_gpu_node_pool         = true
aks_gpu_node_pool_name    = "gpupool"
aks_gpu_node_pool_vm_size = "Standard_NC4as_T4_v3"

add_aial_node_pool           = false
aks_aial_node_pool_name      = "aialpool"
aks_aial_node_pool_vm_size   = "Standard_NC4as_T4_v3"
aks_aial_node_pool_min_count = 0
aks_aial_node_pool_max_count = 1

###########################################################
#  Nginx Ingress Controller Configuration
###########################################################
# cf. https://github.com/kubernetes/ingress-nginx/releases
nginx_ingress_helm_chart_version = "4.6.1"