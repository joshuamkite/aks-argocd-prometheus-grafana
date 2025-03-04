

resource "azurerm_resource_group" "this" {
  name     = "rg-${var.project}-${var.environment}"
  location = var.location
}

module "aks" {
  source              = "Azure/aks/azurerm"
  version             = "9.4.1"
  resource_group_name = azurerm_resource_group.this.name
  prefix              = var.project
  rbac_aad            = var.rbac_aad
  agents_size         = var.agents_size
  agents_count        = var.agents_count
  agents_max_count    = var.agents_max_count
  agents_min_count    = var.agents_min_count
  agents_pool_name    = var.agents_pool_name
  enable_auto_scaling = var.enable_auto_scaling

  # For public access
  private_cluster_enabled = false

  # Required for Application Gateway integration
  network_plugin = "azure"

  depends_on = [
    azurerm_resource_group.this
  ]
}

