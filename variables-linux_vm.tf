variable "linux_vm" {
  description = <<EOT
    (Required) The Linux Virtual Machines to be created.
    
    VIRTUAL MACHINE DETAILS

    `linux_vm_name`           - (Required) The name of the Linux Virtual Machine. Changing this forces a new resource to be created.
    
    `linux_vm_size`           - (Required) The SKU which should be used for this Virtual Machine, such as Standard_F2.
    
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

      `nic_ip_config`                       -  (Required) One or more ip_configuration blocks as defined below.
          `nic_ip_config_name`                  - (Required) A name used for this IP Configuration.
          `nic_ip_config_private_ip_allocation` - (Required) The allocation method used for the Private IP Address. Possible values are Dynamic and Static. Defaults to Dynamic.
          `nic_ip_config_private_ip_address`    - (Optional) The Static IP Address which should be used. Required when nic_ip_config_private_ip_allocation = "Static".
          `nic_ip_config_public_ip_id`          - (Optional) Reference to a Public IP Address to associate with this NIC
          `nic_ip_config_primary`               - (Optional) Is this the Primary IP Configuration? Must be true for the first nic_ip_config when multiple are specified. Defaults to false.

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

      `nic_ip_config`                       -  (Required) One or more ip_configuration blocks as defined below.
          `nic_ip_config_name`                  - (Required) A name used for this IP Configuration.
          `nic_ip_config_private_ip_allocation` - (Required) The allocation method used for the Private IP Address. Possible values are Dynamic and Static. Defaults to Dynamic.
          `nic_ip_config_private_ip_address`    - (Optional) The Static IP Address which should be used. Required when nic_ip_config_private_ip_allocation = "Static".
          `nic_ip_config_public_ip_id`          - (Optional) Reference to a Public IP Address to associate with this NIC
          `nic_ip_config_primary`               - (Optional) Is this the Primary IP Configuration? Must be true for the first nic_ip_config when multiple are specified. Defaults to false.

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

    `linux_vm_os_disk_type`  - (Optional) The Type of Storage Account which should back this the Internal OS Disk. Possible values are Standard_LRS, StandardSSD_LRS, Premium_LRS, StandardSSD_ZRS and Premium_ZRS. Changing this forces a new resource to be created. Defaults to Standard_LRS.
    
    `linux_vm_os_disk_cache` - (Optional) The Type of Caching which should be used for the Internal OS Disk. Possible values are None, ReadOnly and ReadWrite. Defaults to None.
    
    `linux_vm_os_disk_size`  - (Optional) The Size of the Internal OS Disk in GB, if you wish to vary from the size used in the image this Virtual Machine is sourced from.
                                  If specified this must be equal to or larger than the size of the Image the Virtual Machine is based on. When creating a larger disk than exists in the image you'll need to repartition the disk to use the remaining space.
    
    `linux_vm_os_disk_write_accelerator_enabled` - (Optional) Should Write Accelerator be Enabled for this OS Disk? Defaults to false. This requires that the `linux_vm_os_disk_type` is set to "Premium_LRS" and that `linux_vm_os_disk_cache` is set to "None".
                                                   For supported SKUs check https://docs.microsoft.com/en-us/azure/virtual-machines/how-to-enable-write-accelerator#restrictions-when-using-write-accelerator.
    
    `linux_vm_os_disk_encryption_set_id` - (Optional) The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk. Conflicts with secure_vm_disk_encryption_set_id.
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

    `linux_vm_dedicated_host_id`         - (Optional) The ID of a Dedicated Host where this machine should be run on. Conflicts with dedicated_host_group_id.

    `linux_vm_boot_diag_uri`             - (Optional) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor.
    
    `linux_vm_ultra_disks_enabled`       - (Optional) Should the capacity to enable Data Disks of the UltraSSD_LRS storage account type be supported on this Virtual Machine? Defaults to false.
                                           When set to true, the linux_vm_zone property needs to be set as well.
    
    `linux_vm_patch_mode`                - (Optional) Specifies the mode of in-guest patching to this Linux Virtual Machine. Possible values are AutomaticByPlatform and ImageDefault. Defaults to ImageDefault.
                                           For more information check https://docs.microsoft.com/en-us/azure/virtual-machines/automatic-vm-guest-patching#patch-orchestration-modes.
    
    IDENTITIES

    `linux_vm_identity_type` - (Optional) Specifies the type of Managed Service Identity that should be configured on this Linux Virtual Machine. Possible values are "SystemAssigned", "UserAssigned" or "SystemAssigned, UserAssigned" (to enable both).
    
    `linux_vm_identity_ids`  - (Optional) Specifies a list of User Assigned Managed Identity IDs to be assigned to this Linux Virtual Machine. This is required when `linux_vm_identity_type` is set to "UserAssigned" or "SystemAssigned, UserAssigned".
    
    TAGS

    `linux_vm_custom_tags` - (Optional) A mapping of custom tags which should be appended to the default tags.
    
  EOT
  type = list(object({
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
}

#Global Variables - Used to set default values for all deployed VMs.
#Timeouts
variable "linux_vm_timeout_create" {
  description = "Specify timeout for create action. Defaults to 15 minutes."
  type        = string
  default     = "15m"
}
variable "linux_vm_timeout_update" {
  description = "Specify timeout for update action. Defaults to 15 minutes."
  type        = string
  default     = "15m"
}
variable "linux_vm_timeout_read" {
  description = "Specify timeout for read action. Defaults to 5 minutes."
  type        = string
  default     = "5m"
}
variable "linux_vm_timeout_delete" {
  description = "Specify timeout for delete action. Defaults to 15 minutes."
  type        = string
  default     = "15m"
}

#Credentials
variable "linux_vm_admin_username" {
  description = "(Required) The username of the local administrator used for the Virtual Machine. Changing this forces a new resource to be created. If this variable filled, will be used for all VMs to be deployed, unless overridden."
  type        = string
  default     = null
}
variable "linux_vm_admin_password" {
  description = "(Required) The Password which should be used for the local-administrator on this Virtual Machine. Changing this forces a new resource to be created. If this variable filled, will be used for all VMs to be deployed, unless overridden."
  type        = string
  default     = null
  sensitive   = true
}
variable "linux_vm_password_auth_disabled" {
  description = "(Optional) Should Password Authentication be disabled on this Virtual Machine? Defaults to false. Changing this forces a new resource to be created."
  type        = bool
  default     = true
}
variable "linux_vm_public_keys" {
  description = <<EOT
    A list of objects with the usernames and public keys to be applied on the scaleset.
    One of either `linux_vm_admin_password` or `linux_vm_public_keys` must be specified.

    `linux_vm_username`   - (Required) The Username for which this Public SSH Key should be configured.

    `linux_vm_public_key` - (Required) The Public Key which should be used for authentication, which needs to be at least 2048-bit and in ssh-rsa format.

    EOT
  type = list(object({
    linux_vm_username   = optional(string)
    linux_vm_public_key = optional(string)
  }))
  default = []
}

#Subnet
variable "linux_vm_nic_subnet_id" {
  description = "Reference to a subnet in which NICs will be created. Required when private_ip_address_version is IPv4. This is a Global Variable."
  type        = string
  default     = null
}

#Images
variable "linux_vm_marketplace_image" {
  description = <<EOT
    <!-- markdownlint-disable-file MD033 MD012 -->
    (Required) Whether the image source used for deployment is the Azure Marketplace. Default to false.
    When set to true, the following properties needs to be set: `linux_vm_image_publisher`, `linux_vm_image_offer`, `linux_vm_image_sku`, `linux_vm_image_version`.
    When set to false, the following properties needs to be set: `linux_vm_image_id`.
    EOT
  type        = bool
  default     = false
}
variable "linux_vm_image_id" {
  description = "(Optional) The ID of the Image which this Virtual Machine should be created from. Changing this forces a new resource to be created. If this variable filled, will be used for all VMs to be deployed, unless overridden."
  type        = string
  default     = null
}
variable "linux_vm_image_publisher" {
  description = "(Optional) Specifies the publisher of the image used to create the virtual machines. If this variable filled, will be used for all VMs to be deployed, unless overridden."
  type        = string
  default     = null
}
variable "linux_vm_image_offer" {
  description = "(Optional) Specifies the offer of the image used to create the virtual machines. If this variable filled, will be used for all VMs to be deployed, unless overridden."
  type        = string
  default     = null
}
variable "linux_vm_image_sku" {
  description = "(Optional) Specifies the SKU of the image used to create the virtual machines. If this variable filled, will be used for all VMs to be deployed, unless overridden."
  type        = string
  default     = null
}
variable "linux_vm_image_version" {
  description = "(Optional) Specifies the version of the image used to create the virtual machines. If this variable filled, will be used for all VMs to be deployed, unless overridden."
  type        = string
  default     = null
}

#Custom Data
variable "linux_vm_custom_data" {
  description = "(Optional) The Base64-Encoded Custom Data which should be used for this Virtual Machine. Changing this forces a new resource to be created."
  type        = string
  default     = null
}

#Dedicated Hosts
variable "linux_vm_dedicated_host_id" {
  description = "(Optional) The ID of a Dedicated Host where this machine should be run on. Conflicts with `dedicated_host_group_id`. If this variable filled, will be used for all VMs to be deployed, unless overridden."
  type        = string
  default     = null
}

#Boot Diag
variable "linux_vm_boot_diag_uri" {
  description = "(Optional) The Primary/Secondary Endpoint for the Azure Storage Account which should be used to store Boot Diagnostics, including Console Output and Screenshots from the Hypervisor."
  type        = string
  default     = null
}

#Encryption
variable "linux_vm_host_encryption_enabled" {
  description = "(Optional) Should all of the disks (including the temp disk) attached to this Virtual Machine be encrypted by enabling Encryption at Host? Defaults to false."
  type        = bool
  default     = false
}

variable "linux_vm_os_disk_encryption_set_id" {
  description = "(Optional) The ID of the Disk Encryption Set which should be used to Encrypt this OS Disk. The Disk Encryption Set must have the Reader Role Assignment scoped on the Key Vault - in addition to an Access Policy to the Key Vault."
  type        = string
  default     = null
}

#Gen2 VM Secure Boot
variable "linux_vm_secure_boot_enabled" {
  description = "(Optional) Specifies whether secure boot should be enabled on the virtual machine. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}
variable "linux_vm_vtpm_enabled" {
  description = "(Optional) Specifies whether vTPM should be enabled on the virtual machine. Changing this forces a new resource to be created."
  type        = bool
  default     = false
}

#Ephemeral Disk
variable "linux_vm_os_disk_ephemeral_enabled" {
  description = "(Optional) Whether to enable the Ephemeral OS Disk capability on the VM. Changing this forces a new resource to be created. For more information check https://docs.microsoft.com/en-us/azure/virtual-machines/ephemeral-os-disks-deploy. When enabled it will set `linux_vm_os_disk_cache` to ReadOnly."
  type        = bool
  default     = false
}