terraform {
  required_version = ">= 0.12"
}

provider "azurerm" {
  features {}
}

data "azurerm_resource_group" "rsg" {
    name = var.rsg_name
}

resource "azurerm_public_ip" "pip" {
  name                = local.pip_name
  resource_group_name = data.azurerm_resource_group.rsg.name
  location            = data.azurerm_resource_group.rsg.location
  allocation_method   = local.pip_allocation

  tags = var.tags
}

resource "azurerm_virtual_network" "vnet" {
  name                = var.network.vnet_name
  location            = data.azurerm_resource_group.rsg.location
  resource_group_name = data.azurerm_resource_group.rsg.name
  address_space       = ["10.0.0.0/16"]
  dns_servers         = ["10.0.0.4", "10.0.0.5"]

  subnet {
    name           = var.network.subnet_name
    address_prefix = "10.0.1.0/24"
  }

  tags = var.tags
}

resource "azurerm_storage_account" "sto" {
    name = var.sto_name
    resource_group_name      = data.azurerm_resource_group.rsg.name
    location                 = data.azurerm_resource_group.rsg.location
    account_tier             = "Standard"
    account_replication_type = "GRS"

    tags = var.tags 
}

module "linux-vm" {
    source = "../../"

    resource_group_name = var.rsg_name
    network = {
        rsg = data.azurerm_resource_group.rsg.name
        subnet_name = var.network.subnet_name
        vnet_name = azurerm_virtual_network.vnet.name
    }

    nic_allocation = local.nic_allocation
    nic_public_ip_address_id = azurerm_public_ip.pip.id

    vm_name = var.vm_name
    os = "linux"
    vm_size = var.vm_size
    # zone = "1"

    admin_user = var.admin_username
    public_key = var.public_key

    os_disk = {
        caching = local.caching
        storage_type = local.os_disk_storage_type
        size = local.os_disk_size
    }

    image = {
        publisher = local.publisher
        offer     = local.offer
        sku       = local.sku
        version   = local.version
    }

    storage_uri = azurerm_storage_account.sto.primary_blob_endpoint
}

output "vm_id" {
    value = module.linux-vm.vm_id
}