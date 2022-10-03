resource "azurerm_linux_virtual_machine" "linux_vm" {
  for_each = { for obj in var.linux_vm : obj.linux_vm_name => obj }

  #Timeouts
  timeouts {
    create = coalesce(each.value.linux_vm_timeout_create, var.linux_vm_timeout_create)
    update = coalesce(each.value.linux_vm_timeout_update, var.linux_vm_timeout_update)
    read   = coalesce(each.value.linux_vm_timeout_read, var.linux_vm_timeout_read)
    delete = coalesce(each.value.linux_vm_timeout_delete, var.linux_vm_timeout_delete)
  }

  resource_group_name = var.resource_group_object.name
  location            = var.resource_group_object.location

  name = each.value.linux_vm_name
  size = each.value.linux_vm_size

  #Admin
  admin_username                  = coalesce(each.value.linux_vm_admin_username, var.linux_vm_admin_username)
  admin_password                  = coalesce(each.value.linux_vm_password_auth_disabled, var.linux_vm_password_auth_disabled) ? null : coalesce(each.value.linux_vm_admin_password, var.linux_vm_admin_password)
  disable_password_authentication = coalesce(each.value.linux_vm_password_auth_disabled, var.linux_vm_password_auth_disabled)

  dynamic "admin_ssh_key" {
    for_each = coalesce(each.value.linux_vm_password_auth_disabled, var.linux_vm_password_auth_disabled) ? flatten([
      for e in [
        each.value.linux_vm_public_keys,
        var.linux_vm_public_keys
      ] : e if e != null
    ]) : []
    content {
      username   = admin_ssh_key.value.linux_vm_username
      public_key = admin_ssh_key.value.linux_vm_public_key
    }
  }

  #Zones
  zone = each.value.linux_vm_zone

  #NICs
  network_interface_ids = toset([
    for v in values(module.nic[each.key].nic_interface_list) : v.id
  ])

  #Image
  source_image_id = coalesce(each.value.linux_vm_marketplace_image, var.linux_vm_marketplace_image) ? null : coalesce(each.value.linux_vm_image_id, var.linux_vm_image_id)

  dynamic "source_image_reference" {
    for_each = coalesce(each.value.linux_vm_marketplace_image, var.linux_vm_marketplace_image) ? [1] : []
    content {
      publisher = coalesce(each.value.linux_vm_image_publisher, var.linux_vm_image_publisher)
      offer     = coalesce(each.value.linux_vm_image_offer, var.linux_vm_image_offer)
      sku       = coalesce(each.value.linux_vm_image_sku, var.linux_vm_image_sku)
      version   = coalesce(each.value.linux_vm_image_version, var.linux_vm_image_version, "latest")
    }
  }

  #Patching
  patch_mode = coalesce(each.value.linux_vm_patch_mode, "ImageDefault")

  #OS Disk
  os_disk {
    name                      = "odsk-001-${each.value.linux_vm_name}"
    storage_account_type      = coalesce(each.value.linux_vm_os_disk_type, "Standard_LRS")
    caching                   = coalesce(each.value.linux_vm_os_disk_ephemeral_enabled, var.linux_vm_os_disk_ephemeral_enabled) ? "ReadOnly" : coalesce(each.value.linux_vm_os_disk_cache, "None")
    disk_size_gb              = each.value.linux_vm_os_disk_size
    write_accelerator_enabled = coalesce(each.value.linux_vm_os_disk_write_accelerator_enabled, false)
    disk_encryption_set_id    = try(each.value.linux_vm_os_disk_encryption_set_id, var.linux_vm_os_disk_encryption_set_id)
    #Secure VM
    security_encryption_type         = coalesce(each.value.linux_vm_secure_boot_enabled, var.linux_vm_secure_boot_enabled) && coalesce(each.value.linux_vm_vtpm_enabled, var.linux_vm_vtpm_enabled) ? each.value.linux_vm_os_disk_encryption_type : null
    secure_vm_disk_encryption_set_id = coalesce(each.value.linux_vm_host_encryption_enabled, var.linux_vm_host_encryption_enabled) ? null : try(each.value.linux_vm_os_disk_encryption_set_id, var.linux_vm_os_disk_encryption_set_id)

    dynamic "diff_disk_settings" {
      for_each = coalesce(each.value.linux_vm_os_disk_ephemeral_enabled, var.linux_vm_os_disk_ephemeral_enabled) ? [1] : []
      content {
        option    = "Local"
        placement = coalesce(each.value.linux_vm_os_disk_ephemeral_placement, "CacheDisk")
      }
    }
  }

  #Gen2 VMs
  secure_boot_enabled = each.value.linux_vm_os_disk_encryption_type != null ? true : coalesce(each.value.linux_vm_secure_boot_enabled, var.linux_vm_secure_boot_enabled)
  vtpm_enabled        = each.value.linux_vm_os_disk_encryption_type != null ? true : coalesce(each.value.linux_vm_vtpm_enabled, var.linux_vm_vtpm_enabled)

  #Encryption
  encryption_at_host_enabled = coalesce(each.value.linux_vm_host_encryption_enabled, var.linux_vm_host_encryption_enabled)

  #Custom Data
  custom_data = try(each.value.linux_vm_custom_data, var.linux_vm_custom_data, null)

  #Dedicated Hosts
  dedicated_host_id = try(each.value.linux_vm_dedicated_host_id, var.linux_vm_dedicated_host_id, null)

  #Host Groups --> to be developed
  # dedicated_host_group_id = 

  #Additonal Capabilities
  additional_capabilities {
    ultra_ssd_enabled = coalesce(each.value.linux_vm_ultra_disks_enabled, false)
  }

  #Boot Diagnostics
  boot_diagnostics {
    storage_account_uri = try(each.value.linux_vm_boot_diag_uri, var.linux_vm_boot_diag_uri, null)
  }

  #Identity
  dynamic "identity" {
    for_each = each.value.linux_vm_identity_type != null ? [1] : []
    content {
      type         = each.value.linux_vm_identity_type
      identity_ids = each.value.linux_vm_identity_type == "UserAssigned" || each.value.linux_vm_identity_type == "SystemAssigned, UserAssigned" ? each.value.linux_vm_identity_ids : null
    }
  }

  #Tags
  tags = each.value.linux_vm_custom_tags != null ? merge(local.tags, each.value.linux_vm_custom_tags) : local.tags

}