output "linux_vm_list" {
  value = { for o in azurerm_linux_virtual_machine.linux_vm : o.name => { name : o.name, id : o.id } }
}