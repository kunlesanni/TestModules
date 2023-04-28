variable "nb_instances" {
  description = "Specify the number of vm instances."
  type        = number
}

variable "nb_data_disk" {
  description = "(Optional) Number of the data disks attached to each virtual machine."
  type        = number
}

variable "vm_hostname" {
  description = "local name of the Virtual Machine."
  type        = string
}

variable "rgdata" {
  description = "The name of the resource group in which the resources will be created."
  type        = string
}

variable "location" {
  description = "(Optional) The location in which the resources will be created."
  type        = string
  default     = "uksouth"
}

variable "vnetdata_rg" {
  description = "Resource Group of existing Vnet to connect to"
  default     = "rg-vlz-connectivity-uks"
}

variable "vnetdata" {
  description = "The virtual network where the virtual machines will reside."
  type        = string
  default     = "vnet-dev-uks"
}

variable "subnetdata" {
  description = "The subnet id of the virtual network where the virtual machines will reside."
  type        = string
  default     = "sn-AppFrontend-Nonprod"
}

variable "vm_size" {
  description = "The size of the Virtual Machine."
  # default     = "Standard_B2ms"
}

variable "galleryRG" {
  default     = "rg-isd-iaas-dev"
  description = "Resource group name where Image Gallery is present."
}

variable "galleryName" {
  default     = "CompGlrIsdIaasDev"
  description = "Azure Compute gallery name."
}

variable "Imgdefinition" {
  description = "Azure Compute gallery Image Definition."
}

variable "Imgversion" {
  description = "Azure Compute gallery Image Version."
  # default = "1.2.1"
  default = "latest"
}

variable "kv_id" {
  default     = "/subscriptions/39fb3caa-1f49-4a1b-8b9e-d9394c3999be/resourceGroups/rg-isd-iaas-dev/providers/Microsoft.KeyVault/vaults/kVIsdPlatformNonprod"
  description = "The Resource ID of the Key Vault where secret is stored"
}

variable "vmpwd" {
  default     = "2019-2022-LocalAdmin"
  description = "secret name in kv"
}

variable "admin_username" {
  description = "The admin username of the VM that will be deployed."
  type        = string
  default     = "ccspsvr"
}

variable "extra_disks" {
  description = "(Optional) List of extra data disks attached to each virtual machine."
  type = list(object({
    name = string
    size = number
  }))
  default = [
    {
      size = 5
      name = "datadisk1"
    },
    {
      size = 10
      name = "datadisk2"
    }
  ]
}

variable "disk_size_gb" {
  type        = string
  description = "description"
}

variable "tags" {
  description = "description"
}