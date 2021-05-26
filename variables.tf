# General Variables
variable "resource_group_name" {
  type = string
  description = "(Required) Name of the resource group where the virtaul machine will be deployed"
}

variable "tags" {
  type = map(any)
  description = "(Optional) A mapping of tags to assign to the resource."
  default = {}
}

# Network Variables
variable "network" {
  type = object({
      vnet_name = string
      subnet_name = string
      rsg = string
  })
  description = "(Required) Azure networking detail that are necesary to deploy a new virtual machine"
}

variable "nic_name" {
  type = string
  description = "(Optional) Name of the Network Interface that will be associated to the virtual machine"
  default = ""
}

variable "nic_dns_servers" {
    type = list(string)
    description = "(Optional) DNS Servers"
    default = null
}

variable "nic_enable_accelerated_networking" {
    type = bool
    description = "(Optional) Should Accelerated Networking be enabled? "
    default = false
}

variable "nic_enable_ip_forwarding" {
    type = bool
    description = "(Optional) Should IP Forwarding be enabled?"
    default = false
}

variable "nic_ip_configuration_name" {
    type = string
    description = "(Optional) Name of the NIC ip configuration."
    default = "internal"
}

variable "nic_ip_version" {
    type = string
    description = "(Optional) IP version. Should be IPv4 or IPv6"
    default = "IPv4"
}

variable "nic_allocation" {
    type = string
    description = "(Required) The allocation method used for the Private IP Address. Possible values are Dynamic and Static"
}

variable "nic_private_ip_address" {
    type = string
    description = "(Optional) The Static IP Address which should be used. When private_ip_address_allocation is set to Static the following fields can be configured"
    default = null
}

variable "nic_public_ip_address_id" {
    type = string
    description =  "(Optional) Reference to a Public IP Address to associate with this NIC."
    default = null
}

# Virtual Machine Variables
variable "vm_name" {
    type = string
    description = "(Required) Name of the virtual machine that will be deployed"
}

variable "vm_size" {
    type = string
    description = "(Required) Size of the virtual machine that will be deployed"
}

variable "admin_user" {
    type = string 
    description = "(Required) Username for the admin user"
}

variable "public_key" {
    type = string
    description = "(Linux Required) Name of the file where the public key is"
    default = null
}

variable "disable_password_authentication" {
    type = bool
    description = "(Optional) Should Password Authentication be disabled on this Virtual Machine?"
    default = true
}

variable "availability_set_id" {
    type = string
    description = "(Optional) Specifies the Orchestrated Virtual Machine Scale Set that this Virtual Machine should be created within."
    default = null
}

variable "zone" {
    type = string
    description = "(Optional) The Zone in which this Virtual Machine should be created."
    default = null
}

variable "os_disk" {
    type = object({
        caching = string
        storage_type = string
        size = number
    })
    description = "(Required) OS Disk information"
}

variable "ultra_ssd_enabled" {
    type = bool
    description = "(Optional) Should the capacity to enable Data Disks of the UltraSSD_LRS storage account type be supported on this Virtual Machine?"
    default = false
}

variable "image" {
    type = object({
        publisher = string
        offer = string
        sku = string
        version = string
    })
    description = "Source Image information"
}

variable "storage_uri" {
    type = string
    description = "(Optional) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics."
    default = null
}