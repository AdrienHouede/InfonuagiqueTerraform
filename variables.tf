variable "resource_group_name" {
  description = "Infonuagique dans Paris"
  type        = string
  default     = "infonuagique-resource-group"
}

variable "location" {
  description = "Azure region where the resources will be created"
  type        = string
  default     = "West Europe"
}

variable "vm_name" {
  description = "Adrien_Infonuagique"
  type        = string
  default     = "flask-vm"
}

variable "vm_size" {
  type    = string
  default = "Standard_B1s"
}

variable "admin_username" {
  description = "The admin username for the virtual machine"
  type        = string
  default     = "adrien"
}

variable "admin_password" {
  description = "The admin password for the virtual machine"
  type        = string
  sensitive   = true
}
