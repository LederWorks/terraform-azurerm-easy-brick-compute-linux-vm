# NIC sub module
module "nic" {
  source  = "LederWorks/easy-brick-network-nic/azurerm"
  version = "0.1.0"

  for_each = { for obj in var.linux_vm : obj.linux_vm_name => obj }

  #Subscription
  subscription_id = var.subscription_id

  #Resource Group
  resource_group_object = var.resource_group_object

  #Tags
  tags = local.tags

  #Global Variables

  nic_subnet_id = var.linux_vm_nic_subnet_id

  #Variables

  nic_default_interface = each.value.linux_vm_default_nic

  nic_additional_interface = each.value.linux_vm_additional_nic
}