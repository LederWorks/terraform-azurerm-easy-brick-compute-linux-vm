locals {
  #Tags
  tags = merge({
    creation-mode                                 = "terraform",
    terraform-azurerm-easy-brick-compute-linux-vm = "True"
  }, var.tags)
}