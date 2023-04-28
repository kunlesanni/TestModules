terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.53.0"
    }
  }
}

locals {
  vm_name = "vm-${var.vm_hostname}"
}

data "azurerm_subnet" "subnetdata" {
  name                 = var.subnetdata
  virtual_network_name = var.vnetdata
  resource_group_name  = var.vnetdata_rg
}

data "azurerm_shared_image_version" "srcimgdata" {
  resource_group_name = var.galleryRG
  gallery_name        = var.galleryName
  image_name          = var.Imgdefinition
  name                = var.Imgversion
}

data "azurerm_key_vault_secret" "vmpwd" {
  name         = var.vmpwd
  key_vault_id = var.kv_id
}

resource "azurerm_network_interface" "nic" {
  count                         = var.nb_instances
  name                          = "${local.vm_name}${count.index + 1}-nic"
  resource_group_name           = var.rgdata
  location                      = var.location
  enable_accelerated_networking = false

  ip_configuration {
    name                          = "${local.vm_name}${count.index + 1}-ipconfig"
    subnet_id                     = data.azurerm_subnet.subnetdata.id
    private_ip_address_allocation = "Dynamic"
  }
  tags = var.tags
  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
  
}

resource "azurerm_virtual_machine" "vm-windows" {
  count                            = var.nb_instances
  name                             = "${local.vm_name}${count.index + 1}"
  resource_group_name              = var.rgdata
  location                         = var.location
  availability_set_id              = azurerm_availability_set.avset.id
  vm_size                          = var.vm_size
  network_interface_ids            = [element(azurerm_network_interface.nic.*.id, count.index + 1)]
  delete_os_disk_on_termination    = true
  delete_data_disks_on_termination = true
  tags                             = var.tags

  storage_image_reference {
    id = data.azurerm_shared_image_version.srcimgdata.id
  }

  os_profile {
    computer_name  = "${local.vm_name}${count.index + 1}"
    admin_username = var.admin_username
    admin_password = data.azurerm_key_vault_secret.vmpwd.value
  }

  storage_os_disk {
    name              = "${local.vm_name}${count.index + 1}-osdisk"
    create_option     = "FromImage"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    disk_size_gb      = 127
  }

  storage_data_disk{
    name              = "${local.vm_name}${count.index + 1}-defaultdatadisk"
    disk_size_gb      = 10
    create_option     = "Empty"
    caching           = "ReadWrite"
    managed_disk_type = "Standard_LRS"
    lun               = 4
  }
    
  dynamic "storage_data_disk" {
    for_each = range(var.nb_data_disk)
    content {
      # name              = "${var.vm_hostname}-datadisk${storage_data_disk.value+1}"
      name              = "${local.vm_name}${count.index + 1}-datadisk${storage_data_disk.value + 1}"
      create_option     = "Empty"
      lun               = storage_data_disk.value + 5
      disk_size_gb      = var.disk_size_gb
      caching           = "ReadWrite"
      managed_disk_type = "Standard_LRS"
    }
  }

  os_profile_windows_config {
    provision_vm_agent = true
  }

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

}

resource "azurerm_availability_set" "avset" {
  name                         = "${var.vm_hostname}-avset"
  resource_group_name          = var.rgdata
  location                     = var.location
  platform_fault_domain_count  = 2
  platform_update_domain_count = 6
  managed                      = true
  tags                         = var.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }
}

resource "azurerm_virtual_machine_extension" "lgpo" {
  count                = var.nb_instances
  name                 = "hostname"
  virtual_machine_id   = azurerm_virtual_machine.vm-windows[count.index].id
  publisher            = "Microsoft.Compute"
  type                 = "CustomScriptExtension"
  type_handler_version = "1.9"

  settings = <<SETTINGS
    {
        "fileUris": ["https://stgisdiaasimgdev.blob.core.windows.net/iaasimages/gold_image_extn.ps1"],

        "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file gold_image_extn.ps1"

        }   
SETTINGS

tags                   = var.tags

  lifecycle {
    ignore_changes = [
      tags,
    ]
  }

}

# Working domjoi, need to merge into single script with lgpo?
# resource "azurerm_virtual_machine_extension" "domjoin" {
#   for_each             = local.vm_name
#   name                 = "domainjoinadtest"
#   virtual_machine_id   = azurerm_virtual_machine.vm[each.key].id
#   publisher            = "Microsoft.Compute"
#   type                 = "CustomScriptExtension"
#   type_handler_version = "1.10"

#   settings = <<SETTINGS
#     {
#         "fileUris": ["https://stgisdiaasimgdev.blob.core.windows.net/iaasimages/domain_join_adtest.ps1"],

#         "commandToExecute": "powershell -ExecutionPolicy Unrestricted -file domain_join_adtest.ps1"

#         }   
# SETTINGS
# }
