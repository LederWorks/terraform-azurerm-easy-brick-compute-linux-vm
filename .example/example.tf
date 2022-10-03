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