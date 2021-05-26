locals {
    os_disk_storage_type = "Standard_LRS"
    os_disk_size = 30
    nic_allocation = "Dynamic"
    caching = "ReadWrite"
    publisher = "Canonical"
    offer = "UbuntuServer"
    sku = "16.04-LTS"
    version = "latest"
    pip_name = "fwk-pip"
    pip_allocation = "Static"
}