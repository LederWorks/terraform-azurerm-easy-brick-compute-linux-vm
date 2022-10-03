<!-- BEGIN_TF_DOCS -->
<!-- markdownlint-disable-file MD033 MD012 -->
# terraform-azurerm-easy-brick-compute-linux-vm
LederWorks Easy Compute Linux VM Brick Module

This module were created by [LederWorks](https://lederworks.com) IaC enthusiasts.

## About This Module
This module implements the [linux vm](https://lederworks.com/docs/microsoft-azure/bricks/compute/#linux-vm) reference Insight.

## How to Use This Modul
- Ensure Azure credentials are [in place](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs#authenticating-to-azure) (e.g. `az login` and `az account set --subscription="SUBSCRIPTION_ID"` on your workstation)
    - Owner role or equivalent is required!
- Ensure pre-requisite resources are created.
- Create a Terraform configuration that pulls in this module and specifies values for the required variables.

## Requirements

The following requirements are needed by this module:

- <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) (>=1.3.0)

- <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) (>= 3.24.0)

## Providers

The following providers are used by this module:

- <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) (>= 3.24.0)

## Example

```hcl
#Resource Group
resource "azurerm_resource_group" "compute-linux-vm" {
  name     = "compute-linux-vm"
  location = "East US 2"
  tags     = local.tags
}

#Public IP
resource "azurerm_public_ip" "public-ip1" {
  name                = "public-ip1"
  resource_group_name = azurerm_resource_group.compute-linux-vm.name
  location            = azurerm_resource_group.compute-linux-vm.location
  allocation_method   = "Static"
  sku                 = "Standard"
}

#Custom BootDiag
resource "azurerm_storage_account" "bootdiag" {
  name                      = "bootdiag"
  resource_group_name       = azurerm_resource_group.compute-linux-vm.name
  location                  = azurerm_resource_group.compute-linux-vm.location
  account_tier              = "Standard"
  account_kind              = "StorageV2"
  account_replication_type  = "LRS"
  enable_https_traffic_only = "true"
  min_tls_version           = "TLS1_2"

  tags = local.tags
}

#Linux VM Module
module "compute-linux-vm" {
  source  = "LederWorks/easy-brick-compute-linux-vm/azurerm"
  version = "X.X.X"

  #Subscription
  subscription_id = data.azurerm_client_config.current.subscription_id

  #Resource Group
  resource_group_object = azurerm_resource_group.compute-linux-vm

  #Tags
  tags = local.tags

  ##########################
  #### Global Variables ####
  ##########################

  #Timeout
  linux_vm_timeout_create = "20m"
  linux_vm_timeout_update = "20m"
  linux_vm_timeout_read   = "10m"
  linux_vm_timeout_delete = "20m"

  #Credentials
  linux_vm_admin_username         = ""
  linux_vm_admin_password         = ""
  linux_vm_password_auth_disabled = false
  linux_vm_public_keys = [
    {
      linux_vm_username   = ""
      linux_vm_public_key = "key1"
    }
  ]

  #Subnet
  linux_vm_nic_subnet_id = data.terraform_remote_state.va2_infrastructure.outputs.snet-tva2-ic-linux-vm.id

  #Gen2 VMs
  linux_vm_secure_boot_enabled = true
  linux_vm_vtpm_enabled        = true

  #Encryption
  linux_vm_host_encryption_enabled = true

  #Image
  linux_vm_marketplace_image = true
  linux_vm_image_id          = ""
  linux_vm_image_publisher   = "Canonical"
  linux_vm_image_offer       = "UbuntuServer"
  linux_vm_image_sku         = "18.04-LTS"
  linux_vm_image_version     = "latest"

  #Dedicated Hosts
  linux_vm_dedicated_host_id = ""

  #Boot Diag
  linux_vm_boot_diag_uri = azurerm_storage_account.bootdiag.primary_blob_endpoint

  ###################
  #### Linux VMs ####
  ###################

  linux_vm = [

    ##########################################
    #### Virtual Machine 1 - Full Example ####
    ##########################################
    {
      #Name
      linux_vm_name = "vm001"

      #Size
      linux_vm_size = "Standard_D2s_v3"

      #Zone
      linux_vm_zone = "3"

      #Credentials
      linux_vm_admin_username         = data.terraform_remote_state.va2_terratest.outputs.LocalAdminUserName
      linux_vm_admin_password         = data.terraform_remote_state.va2_terratest.outputs.LocalAdminKeyVaultSecret2
      linux_vm_password_auth_disabled = true
      linux_vm_public_keys = [
        {
          linux_vm_username   = ""
          linux_vm_public_key = "key2"
        },
        {
          linux_vm_username   = ""
          linux_vm_public_key = "key3"
        },
      ]

      #Default Network Interface
      linux_vm_default_nic = {
        nic_name                           = "vnic-001"
        nic_subnet_id                      = ""
        nic_dns_servers                    = []
        nic_edge_zone                      = ""
        nic_ip_forwarding_enabled          = true
        nic_accelerated_networking_enabled = true
        nic_internal_dns_name_label        = ""

        nic_ip_config = [
          #primary
          {
            nic_ip_config_name                  = "primary"
            nic_ip_config_primary               = true
            nic_ip_config_private_ip_allocation = "Static"
            nic_ip_config_private_ip_address    = "192.168.169.170"
            nic_ip_config_public_ip_id          = ""
          },
          #secondary
          {
            nic_ip_config_name = "secondary"
          }
        ]
      }

      #Additional Network Interfaces
      linux_vm_additional_nic = [
        #NIC2
        {
          nic_name = "vnic-002"
          nic_ip_config = [
            {
              nic_ip_config_name    = "primary"
              nic_ip_config_primary = true
            },
            {
              nic_ip_config_name = "secondary"
            }
          ]
        },
        #NIC3
        {
          nic_name = "vnic-003"
          nic_ip_config = [
            {
              nic_ip_config_name    = "primary"
              nic_ip_config_primary = true
            },
            {
              nic_ip_config_name = "secondary"
            }
          ]
        }
      ]


      #Image
      linux_vm_marketplace_image = true
      linux_vm_image_id          = ""
      linux_vm_image_publisher   = "Canonical"
      linux_vm_image_offer       = "UbuntuServer"
      linux_vm_image_sku         = "18.04-LTS"
      linux_vm_image_version     = "latest"

      #OS Disk
      linux_vm_os_disk_type            = "Premium_LRS"
      linux_vm_os_disk_cache           = "ReadWrite"
      linux_vm_os_disk_size            = 127
      linux_vm_os_disk_encryption_type = "DiskWithVMGuestState"
      linux_vm_host_encryption_enabled = false

      #Bootdiag
      linux_vm_boot_diag_uri = null #Used for managed bootdiag

      #Capabilities
      linux_vm_dedicated_host_id         = ""
      linux_vm_ultra_disks_enabled       = true
      linux_vm_automatic_updates_enabled = true
      linux_vm_patch_mode                = ""

      #Custom Data Block
      linux_vm_custom_data = base64encode("auth: true")

      #Identities
      linux_vm_identity_type = "SystemAssigned, UserAssigned"
      linux_vm_identity_ids  = ["", ""]

      #Custom Tags
      linux_vm_custom_tags = {
        1       = "two",
        "three" = 4
      }

      #Timeouts
      linux_vm_timeout_create = "20m"
      linux_vm_timeout_update = "20m"
      linux_vm_timeout_read   = "10m"
      linux_vm_timeout_delete = "20m"

    },

    ############################################
    #### Virtual Machine 2 - Ephemeral Disk ####
    ############################################
    {
      linux_vm_name     = "vm002"
      linux_vm_size     = "Standard_D2s_v3"
      linux_vm_zone     = "3"
      linux_vm_image_id = ""
      linux_vm_default_nic = {
        nic_name = "vnic-004"
        nic_ip_config = [{
          nic_ip_config_name         = "primary"
          nic_ip_config_primary      = true
          nic_ip_config_public_ip_id = azurerm_public_ip.public-ip.id
        }]
      }
      linux_vm_os_disk_size              = 49
      linux_vm_os_disk_ephemeral_enabled = true
      linux_vm_custom_data               = base64encode("auth: true")
    },

    #########################################
    #### Virtual Machine 2 - Secure Boot ####
    #########################################
    {
      linux_vm_name = "vm003"
      linux_vm_size = "Standard_D2s_v3"
      linux_vm_zone = "3"
      linux_vm_default_nic = {
        nic_name = "vnic-005"

        nic_ip_config = [{
          nic_ip_config_name    = "primary"
          nic_ip_config_primary = true
        }]
      }
      linux_vm_os_disk_size        = 127
      linux_vm_secure_boot_enabled = true
      linux_vm_vtpm_enabled        = true
      linux_vm_custom_data         = base64encode("auth: true")
    }
  ]
}

#Outputs
#auth
output "tenant_id" {
  value = data.azurerm_client_config.current.tenant_id
}
output "subscription_id" {
  value = data.azurerm_client_config.current.subscription_id
}
output "client_id" {
  value = data.azurerm_client_config.current.client_id
}

#rgrp
output "resource_group_name" {
  value = azurerm_resource_group.compute-linux-vm.name
}

#linux_vm
output "linux_vm_list" {
  value = module.compute-linux-vm.linux_vm_list
}
```

## Resources

The following resources are used by this module:

- [azurerm_linux_virtual_machine.linux_vm](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/linux_virtual_machine) (resource)

## Required Inputs

The following input variables are required:

### <a name="input_linux_vm"></a> [linux\_vm](#input\_linux\_vm)

Description:     (Required) The Linux Virtual Machines to be created.  

    VIRTUAL MACHINE DETAILS

    `linux_vm_name`           - (Required) The name of the Linux Virtual Machine. Changing this forces a new resource to be created.

    `linux_vm_size`           - (Required) The SKU which should be used for this Virtual Machine, such as Standard\_F2.  

    CREDENTIALS

    `linux_vm_admin_username`         - (Required) The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created.

    `linux_vm_admin_password`         - (Optional) The Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created.

    `linux_vm_password_auth_disabled` - (Optional) Should Password Authentication be disabled on this Virtual Machine? Defaults to false. Changing this forces a new resource to be created.

    `linux_vm_public_keys`             - (Optional) A list of objects with the usernames and public keys to be applied on the scaleset. One of either `linux_vm_admin_password` or `linux_vm_public_keys` must be specified.

      `linux_vm_username`   - (Required) The Username for which this Public SSH Key should be configured.

      `linux_vm_public_key` - (Required) The Public Key which should be used for authentication, which needs to be at least 2048-bit and in ssh-rsa format.  

    DEFAULT NETWORK INTERFACE

    `linux_vm_default_nic` - (Required) The default Network Interfaces to be created. This is an object().

      `nic_name`                            - (Required) The name of the Network Interface. Changing this forces a new resource to be created.

      `nic_subnet_id`                       - (Optional) The ID of the Subnet where this Network Interface should be located in.

      `nic_dns_servers`                     - (Optional) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface.   
                                            Configuring DNS Servers on the Network Interface will override the DNS Servers defined on the Virtual Network.

      `nic_edge_zone`                       - (Optional) Specifies the Edge Zone within the Azure Region where this Network Interface should exist. Changing this forces a new Network Interface to be created.

      `nic_ip_forwarding_enabled`           - (Optional) Should IP Forwarding be enabled? Defaults to false.

      `nic_accelerated_networking_enabled`  - (Optional) Should Accelerated Networking be enabled? Defaults to false.   
                                            Only certain Virtual Machine sizes are supported for Accelerated Networking.  
                                            For more information check https://docs.microsoft.com/en-us/azure/virtual-network/create-vm-accelerated-networking-cli.  
                                            To use Accelerated Networking in an Availability Set, the Availability Set must be deployed onto an Accelerated Networking enabled cluster.

      `nic_internal_dns_name_label`         - (Optional) The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network.

      `nic_ip_config`                       -  (Required) One or more ip\_configuration blocks as defined below.
          `nic_ip_config_name`                  - (Required) A name used for this IP Configuration.
          `nic_ip_config_private_ip_allocation` - (Required) The allocation method used for the Private IP Address. Possible values are Dynamic and Static. Defaults to Dynamic.
          `nic_ip_config_private_ip_address`    - (Optional) The Static IP Address which should be used. Required when nic\_ip\_config\_private\_ip\_allocation = "Static".
          `nic_ip_config_public_ip_id`          - (Optional) Reference to a Public IP Address to associate with this NIC
          `nic_ip_config_primary`               - (Optional) Is this the Primary IP Configuration? Must be true for the first nic\_ip\_config when multiple are specified. Defaults to false.

    ADDITIONAL INTERFACE

    `linux_vm_additional_nic` - (Optional) List of additional Network Interfaces to be created. This is a list(object()).

      `nic_name`                            - (Required) The name of the Network Interface. Changing this forces a new resource to be created.

      `nic_subnet_id`                       - (Optional) The ID of the Subnet where this Network Interface should be located in.

      `nic_dns_servers`                     - (Optional) A list of IP Addresses defining the DNS Servers which should be used for this Network Interface.   
                                              Configuring DNS Servers on the Network Interface will override the DNS Servers defined on the Virtual Network.

      `nic_edge_zone`                       - (Optional) Specifies the Edge Zone within the Azure Region where this Network Interface should exist. Changing this forces a new Network Interface to be created.

      `nic_ip_forwarding_enabled`           - (Optional) Should IP Forwarding be enabled? Defaults to false.

      `nic_accelerated_networking_enabled`  - (Optional) Should Accelerated Networking be enabled? Defaults to false.   
                                              Only certain Virtual Machine sizes are supported for Accelerated Networking.  
                                              For more information check https://docs.microsoft.com/en-us/azure/virtual-network/create-vm-accelerated-networking-cli.  
                                              To use Accelerated Networking in an Availability Set, the Availability Set must be deployed onto an Accelerated Networking enabled cluster.

      `nic_internal_dns_name_label`         - (Optional) The (relative) DNS Name used for internal communications between Virtual Machines in the same Virtual Network.

      `nic_ip_config`                       -  (Required) One or more ip\_configuration blocks as defined below.
          `nic_ip_config_name`                  - (Required) A name used for this IP Configuration.
          `nic_ip_config_private_ip_allocation` - (Required) The allocation method used for the Private IP Address. Possible values are Dynamic and Static. Defaults to Dynamic.
          `nic_ip_config_private_ip_address`    - (Optional) The Static IP Address which should be used. Required when nic\_ip\_config\_private\_ip\_allocation = "Static".
          `nic_ip_config_public_ip_id`          - (Optional) Reference to a Public IP Address to associate with this NIC
          `nic_ip_config_primary`               - (Optional) Is this the Primary IP Configuration? Must be true for the first nic\_ip\_config when multiple are specified. Defaults to false.

    AVAILABILITY ZONES

    `linux_vm_zone`           - (Optional) Specifies the Availability Zone in which this Linux Virtual Machine should be located. Changing this forces a new Linux Virtual Machine to be created.  

    IMAGE

    `linux_vm_marketplace_image` - (Required) Whether the image source used for deployment is the Azure Marketplace. Default to false.  
                                     When set to true, the following properties needs to be set: `linux_vm_image_publisher`, `linux_vm_image_offer`, `linux_vm_image_sku`, `linux_vm_image_version`.  
                                     When set to false, the following properties needs to be set: `linux_vm_image_id`.

    `linux_vm_image_id`          - (Optional) The ID of the Image which this Virtual Machine should be created from. Changing this forces a new resource to be created.

    `linux_vm_image_publisher`   - (Optional) Specifies the publisher of the image used to create the virtual machines.

    `linux_vm_image_offer`       - (Optional) Specifies the offer of the image used to create the virtual machines.

    `linux_vm_image_sku`         - (Optional) Specifies the SKU of the image used to create the virtual machines.

    `linux_vm_image_version`     -  (Optional) Specifies the version of the image used to create the virtual machines.

    OS DISK

    `linux_vm_os_disk_type`  - (Optional) The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard\_LRS, StandardSSD\_LRS, Premium\_LRS, StandardSSD\_ZRS and Premium\_ZRS. Changing this forces a new resource to be created. Defaults to Standard\_LRS.

    `linux_vm_os_disk_cache` - (Optional) The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite. Defaults to None.

    `linux_vm_os_disk_size`  - (Optional) The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from.  
                                  If specified this must be equal to or larger than the size of the Image the Virtual Machine is based on. When creating a larger disk than exists in the image you'll need to repartition the disk to use the remaining space.

    `linux_vm_os_disk_write_accelerator_enabled` - (Optional) Should Write Accelerator be Enabled for this OS Disk? Defaults to false. This requires that the `linux_vm_os_disk_type` is set to "Premium\_LRS" and that `linux_vm_os_disk_cache` is set to "None".  
                                                   For supported SKUs check https://docs.microsoft.com/en-us/azure/virtual-machines/how-to-enable-write-accelerator#restrictions-when-using-write-accelerator.

    `linux_vm_os_disk_encryption_set_id` - (Optional) The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk. Conflicts with secure\_vm\_disk\_encryption\_set\_id.  
                                           The Disk Encryption Set must have the Reader Role Assignment scoped on the Key Vault - in addition to an Access Policy to the Key Vault.

    `linux_vm_os_disk_ephemeral_enabled` - (Optional) Whether to enable the Ephemeral OS Disk capability on the VM. Changing this forces a new resource to be created.  
                                           For more information check https://docs.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks-deploy.  
                                           When enabled it will set `linux_vm_os_disk_cache` to ReadOnly.

    `linux_vm_os_disk_ephemeral_placement` - (Optional) Specifies where to store the Ephemeral Disk. Possible values are CacheDisk and ResourceDisk. Defaults to CacheDisk. Changing this forces a new resource to be created.

    `linux_vm_os_disk_encryption_type`     - (Optional) Encryption Type when the Virtual Machine is a Confidential VM. Possible values are VMGuestStateOnly and DiskWithVMGuestState. Changing this forces a new resource to be created.  
                                             When you set this is, it will set `linux_vm_secure_boot_enabled` and `linux_vm_vtpm_enabled` to true.

    GEN2 VM SECURE BOOT

    `linux_vm_secure_boot_enabled` - (Optional) Specifies whether secure boot should be enabled on the virtual machine. Changing this forces a new resource to be created.

    `linux_vm_vtpm_enabled`        - (Optional) Specifies whether vTPM should be enabled on the virtual machine. Changing this forces a new resource to be created.

    ADDITIONAL CAPABILITIES

    `linux_vm_host_encryption_enabled`   - (Optional) Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host? Defaults to false.

    `linux_vm_custom_data`               - (Optional) The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created.

    `linux_vm_dedicated_host_id`         - (Optional) The ID of a Dedicated Host where this machine should be run on. Conflicts with dedicated\_host\_group\_id.

    `linux_vm_boot_diag_uri`             - (Optional) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor.

    `linux_vm_ultra_disks_enabled`       - (Optional) Should the capacity to enable Data Disks of the UltraSSD\_LRS storage account type be supported on this Virtual Machine? Defaults to false.  
                                           When set to true, the linux\_vm\_zone property needs to be set as well.

    `linux_vm_patch_mode`                - (Optional) Specifies the mode of in-guest patching to this Linux Virtual Machine. Possible values are AutomaticByPlatform and ImageDefault. Defaults to ImageDefault.  
                                           For more information check https://docs.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching#patch-orchestration-modes.  

    IDENTITIES

    `linux_vm_identity_type` - (Optional) Specifies the type of Managed Service Identity that should be configured on this Linux Virtual Machine. Possible values are "SystemAssigned", "UserAssigned" or "SystemAssigned, UserAssigned" (to enable both).

    `linux_vm_identity_ids`  - (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Linux Virtual Machine. This is required when `linux_vm_identity_type` is set to "UserAssigned" or "SystemAssigned, UserAssigned".  

    TAGS

    `linux_vm_custom_tags` - (Optional) A mapping of custom tags which should be appended to the default tags.

Type:

```hcl
list(object({
    linux_vm_name = string
    linux_vm_size = string
    #Credentials
    linux_vm_admin_username         = optional(string)
    linux_vm_admin_password         = optional(string)
    linux_vm_password_auth_disabled = optional(bool)
    linux_vm_public_keys = optional(list(object({
      linux_vm_username   = optional(string)
      linux_vm_public_key = optional(string)
    })))
    #Zones
    linux_vm_zone = optional(string)
    #Default NIC
    linux_vm_default_nic = optional(object({
      nic_name                           = string
      nic_subnet_id                      = optional(string)
      nic_dns_servers                    = optional(list(string))
      nic_edge_zone                      = optional(string)
      nic_ip_forwarding_enabled          = optional(bool)
      nic_accelerated_networking_enabled = optional(bool)
      nic_internal_dns_name_label        = optional(bool)
      nic_ip_config = optional(list(object({
        nic_ip_config_name                  = optional(string)
        nic_ip_config_private_ip_allocation = optional(string)
        nic_ip_config_private_ip_address    = optional(string)
        nic_ip_config_public_ip_id          = optional(string)
        nic_ip_config_primary               = optional(bool)
      })))
    }))
    #Additional NICs
    linux_vm_additional_nic = optional(list(object({
      nic_name                           = string
      nic_subnet_id                      = optional(string)
      nic_dns_servers                    = optional(list(string))
      nic_edge_zone                      = optional(string)
      nic_ip_forwarding_enabled          = optional(bool)
      nic_accelerated_networking_enabled = optional(bool)
      nic_internal_dns_name_label        = optional(bool)
      nic_ip_config = list(object({
        nic_ip_config_name                  = string
        nic_ip_config_private_ip_allocation = optional(string)
        nic_ip_config_private_ip_address    = optional(string)
        nic_ip_config_public_ip_id          = optional(string)
        nic_ip_config_primary               = optional(bool)
      }))
    })))
    #Image
    linux_vm_marketplace_image = optional(bool)
    linux_vm_image_id          = optional(string)
    linux_vm_image_publisher   = optional(string)
    linux_vm_image_offer       = optional(string)
    linux_vm_image_sku         = optional(string)
    linux_vm_image_version     = optional(string)
    #OS Disk
    linux_vm_os_disk_type                      = optional(string)
    linux_vm_os_disk_cache                     = optional(string)
    linux_vm_os_disk_size                      = optional(number)
    linux_vm_os_disk_write_accelerator_enabled = optional(bool)
    linux_vm_os_disk_encryption_set_id         = optional(string)
    linux_vm_os_disk_ephemeral_enabled         = optional(bool)
    linux_vm_os_disk_ephemeral_placement       = optional(string)
    linux_vm_os_disk_encryption_type           = optional(string)
    #SSH Keys
    linux_vm_public_keys = optional(list(object({
      linux_vm_username   = optional(string)
      linux_vm_public_key = optional(string)
    })))
    #Gen2 VM Secure Boot
    linux_vm_secure_boot_enabled = optional(string)
    linux_vm_vtpm_enabled        = optional(string)
    #Additional Capabilities
    linux_vm_host_encryption_enabled = optional(bool)
    linux_vm_custom_data             = optional(string)
    linux_vm_dedicated_host_id       = optional(string)
    linux_vm_boot_diag_uri           = optional(string)
    linux_vm_ultra_disks_enabled     = optional(bool)
    linux_vm_patch_mode              = optional(string)
    linux_vm_identity_type           = optional(string)
    linux_vm_identity_ids            = optional(list(string))
    linux_vm_custom_tags             = optional(map(string))
    #Timeouts
    linux_vm_timeout_create = optional(string)
    linux_vm_timeout_update = optional(string)
    linux_vm_timeout_read   = optional(string)
    linux_vm_timeout_delete = optional(string)
  }))
```

### <a name="input_resource_group_object"></a> [resource\_group\_object](#input\_resource\_group\_object)

Description: (Required) Resource Group Object

Type: `any`

### <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id)

Description: (Required) ID of the Subscription

Type: `string`

## Optional Inputs

The following input variables are optional (have default values):

### <a name="input_linux_vm_admin_password"></a> [linux\_vm\_admin\_password](#input\_linux\_vm\_admin\_password)

Description: (Required) The Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created. If this variable filled, will be used for all VMs to be deployed, unless overridden.

Type: `string`

Default: `null`

### <a name="input_linux_vm_admin_username"></a> [linux\_vm\_admin\_username](#input\_linux\_vm\_admin\_username)

Description: (Required) The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created. If this variable filled, will be used for all VMs to be deployed, unless overridden.

Type: `string`

Default: `null`

### <a name="input_linux_vm_boot_diag_uri"></a> [linux\_vm\_boot\_diag\_uri](#input\_linux\_vm\_boot\_diag\_uri)

Description: (Optional) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor.

Type: `string`

Default: `null`

### <a name="input_linux_vm_custom_data"></a> [linux\_vm\_custom\_data](#input\_linux\_vm\_custom\_data)

Description: (Optional) The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created.

Type: `string`

Default: `null`

### <a name="input_linux_vm_dedicated_host_id"></a> [linux\_vm\_dedicated\_host\_id](#input\_linux\_vm\_dedicated\_host\_id)

Description: (Optional) The ID of a Dedicated Host where this machine should be run on. Conflicts with `dedicated_host_group_id`. If this variable filled, will be used for all VMs to be deployed, unless overridden.

Type: `string`

Default: `null`

### <a name="input_linux_vm_host_encryption_enabled"></a> [linux\_vm\_host\_encryption\_enabled](#input\_linux\_vm\_host\_encryption\_enabled)

Description: (Optional) Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host? Defaults to false.

Type: `bool`

Default: `false`

### <a name="input_linux_vm_image_id"></a> [linux\_vm\_image\_id](#input\_linux\_vm\_image\_id)

Description: (Optional) The ID of the Image which this Virtual Machine should be created from. Changing this forces a new resource to be created. If this variable filled, will be used for all VMs to be deployed, unless overridden.

Type: `string`

Default: `null`

### <a name="input_linux_vm_image_offer"></a> [linux\_vm\_image\_offer](#input\_linux\_vm\_image\_offer)

Description: (Optional) Specifies the offer of the image used to create the virtual machines. If this variable filled, will be used for all VMs to be deployed, unless overridden.

Type: `string`

Default: `null`

### <a name="input_linux_vm_image_publisher"></a> [linux\_vm\_image\_publisher](#input\_linux\_vm\_image\_publisher)

Description: (Optional) Specifies the publisher of the image used to create the virtual machines. If this variable filled, will be used for all VMs to be deployed, unless overridden.

Type: `string`

Default: `null`

### <a name="input_linux_vm_image_sku"></a> [linux\_vm\_image\_sku](#input\_linux\_vm\_image\_sku)

Description: (Optional) Specifies the SKU of the image used to create the virtual machines. If this variable filled, will be used for all VMs to be deployed, unless overridden.

Type: `string`

Default: `null`

### <a name="input_linux_vm_image_version"></a> [linux\_vm\_image\_version](#input\_linux\_vm\_image\_version)

Description: (Optional) Specifies the version of the image used to create the virtual machines. If this variable filled, will be used for all VMs to be deployed, unless overridden.

Type: `string`

Default: `null`

### <a name="input_linux_vm_marketplace_image"></a> [linux\_vm\_marketplace\_image](#input\_linux\_vm\_marketplace\_image)

Description:     <!-- markdownlint-disable-file MD033 MD012 -->
    (Required) Whether the image source used for deployment is the Azure Marketplace. Default to false.  
    When set to true, the following properties needs to be set: `linux_vm_image_publisher`, `linux_vm_image_offer`, `linux_vm_image_sku`, `linux_vm_image_version`.  
    When set to false, the following properties needs to be set: `linux_vm_image_id`.

Type: `bool`

Default: `false`

### <a name="input_linux_vm_nic_subnet_id"></a> [linux\_vm\_nic\_subnet\_id](#input\_linux\_vm\_nic\_subnet\_id)

Description: Reference to a subnet in which NICs will be created. Required when private\_ip\_address\_version is IPv4. This is a Global Variable.

Type: `string`

Default: `null`

### <a name="input_linux_vm_os_disk_encryption_set_id"></a> [linux\_vm\_os\_disk\_encryption\_set\_id](#input\_linux\_vm\_os\_disk\_encryption\_set\_id)

Description: (Optional) The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk. The Disk Encryption Set must have the Reader Role Assignment scoped on the Key Vault - in addition to an Access Policy to the Key Vault.

Type: `string`

Default: `null`

### <a name="input_linux_vm_os_disk_ephemeral_enabled"></a> [linux\_vm\_os\_disk\_ephemeral\_enabled](#input\_linux\_vm\_os\_disk\_ephemeral\_enabled)

Description: (Optional) Whether to enable the Ephemeral OS Disk capability on the VM. Changing this forces a new resource to be created. For more information check https://docs.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks-deploy. When enabled it will set `linux_vm_os_disk_cache` to ReadOnly.

Type: `bool`

Default: `false`

### <a name="input_linux_vm_password_auth_disabled"></a> [linux\_vm\_password\_auth\_disabled](#input\_linux\_vm\_password\_auth\_disabled)

Description: (Optional) Should Password Authentication be disabled on this Virtual Machine? Defaults to false. Changing this forces a new resource to be created.

Type: `bool`

Default: `true`

### <a name="input_linux_vm_public_keys"></a> [linux\_vm\_public\_keys](#input\_linux\_vm\_public\_keys)

Description:     A list of objects with the usernames and public keys to be applied on the scaleset.  
    One of either `linux_vm_admin_password` or `linux_vm_public_keys` must be specified.

    `linux_vm_username`   - (Required) The Username for which this Public SSH Key should be configured.

    `linux_vm_public_key` - (Required) The Public Key which should be used for authentication, which needs to be at least 2048-bit and in ssh-rsa format.

Type:

```hcl
list(object({
    linux_vm_username   = optional(string)
    linux_vm_public_key = optional(string)
  }))
```

Default: `[]`

### <a name="input_linux_vm_secure_boot_enabled"></a> [linux\_vm\_secure\_boot\_enabled](#input\_linux\_vm\_secure\_boot\_enabled)

Description: (Optional) Specifies whether secure boot should be enabled on the virtual machine. Changing this forces a new resource to be created.

Type: `bool`

Default: `false`

### <a name="input_linux_vm_timeout_create"></a> [linux\_vm\_timeout\_create](#input\_linux\_vm\_timeout\_create)

Description: Specify timeout for create action. Defaults to 15 minutes.

Type: `string`

Default: `"15m"`

### <a name="input_linux_vm_timeout_delete"></a> [linux\_vm\_timeout\_delete](#input\_linux\_vm\_timeout\_delete)

Description: Specify timeout for delete action. Defaults to 15 minutes.

Type: `string`

Default: `"15m"`

### <a name="input_linux_vm_timeout_read"></a> [linux\_vm\_timeout\_read](#input\_linux\_vm\_timeout\_read)

Description: Specify timeout for read action. Defaults to 5 minutes.

Type: `string`

Default: `"5m"`

### <a name="input_linux_vm_timeout_update"></a> [linux\_vm\_timeout\_update](#input\_linux\_vm\_timeout\_update)

Description: Specify timeout for update action. Defaults to 15 minutes.

Type: `string`

Default: `"15m"`

### <a name="input_linux_vm_vtpm_enabled"></a> [linux\_vm\_vtpm\_enabled](#input\_linux\_vm\_vtpm\_enabled)

Description: (Optional) Specifies whether vTPM should be enabled on the virtual machine. Changing this forces a new resource to be created.

Type: `bool`

Default: `false`

### <a name="input_tags"></a> [tags](#input\_tags)

Description: BYO Tags, as a map(string)

Type: `map(string)`

Default: `null`

## Outputs

The following outputs are exported:

### <a name="output_linux_vm_list"></a> [linux\_vm\_list](#output\_linux\_vm\_list)

Description: n/a

<!-- markdownlint-disable-file MD033 MD012 -->
## Contributing

* If you think you've found a bug in the code or you have a question regarding
  the usage of this module, please reach out to us by opening an issue in
  this GitHub repository.
* Contributions to this project are welcome: if you want to add a feature or a
  fix a bug, please do so by opening a Pull Request in this GitHub repository.
  In case of feature contribution, we kindly ask you to open an issue to
  discuss it beforehand.

## License

```text
MIT License

Copyright (c) 2022 LederWorks

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
```
<!-- END_TF_DOCS -->