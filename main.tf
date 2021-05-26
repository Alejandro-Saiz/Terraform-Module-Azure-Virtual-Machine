data "azurerm_resource_group" "rsg" {
    name = var.resource_group_name
}

data "azurerm_subnet" "vm_subnet" {
  name                 = var.network.subnet_name
  resource_group_name  = var.network.rsg
  virtual_network_name = var.network.vnet_name
}

resource "azurerm_network_interface" "vm_nic" {
  name                          = var.nic_name != "" ? var.nic_name : format("nic-%s",var.vm_name)
  location                      = data.azurerm_resource_group.rsg.location
  resource_group_name           = data.azurerm_resource_group.rsg.name
  dns_servers                   = try(var.nic_dns_servers, null)
  enable_accelerated_networking = var.nic_enable_accelerated_networking
  enable_ip_forwarding          = var.nic_enable_ip_forwarding

  ip_configuration {
    name                            = var.nic_ip_configuration_name
    subnet_id                       = data.azurerm_subnet.vm_subnet.id
    private_ip_address_version      = var.nic_ip_version
    private_ip_address_allocation   = var.nic_allocation
    private_ip_address              = try(var.nic_private_ip_address, null)
    public_ip_address_id            = try(var.nic_public_ip_address_id, null)
  }
}

resource "azurerm_linux_virtual_machine" "vm" {
    name                            = var.vm_name
    resource_group_name             = data.azurerm_resource_group.rsg.name
    location                        = data.azurerm_resource_group.rsg.location
    size                            = var.vm_size
    admin_username                  = var.admin_user
    disable_password_authentication = var.disable_password_authentication
    network_interface_ids           = [azurerm_network_interface.vm_nic.id]
    availability_set_id             = var.availability_set_id != null ? var.availability_set_id : null
    zone                            = var.zone != null ? var.zone : null
    admin_ssh_key {
        username   = var.admin_user
        public_key = file(var.public_key)
    }

    os_disk {
        caching              = var.os_disk.caching
        storage_account_type = var.os_disk.storage_type
        disk_size_gb = var.os_disk.size
    }

    source_image_reference {
        publisher = var.image.publisher
        offer     = var.image.offer
        sku       = var.image.sku
        version   = var.image.version
    }

    additional_capabilities {
        ultra_ssd_enabled = var.ultra_ssd_enabled
    }

    boot_diagnostics {
        storage_account_uri = try(var.storage_uri, null)
    }

    tags = var.tags
}