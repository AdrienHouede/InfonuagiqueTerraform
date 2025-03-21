resource "azurerm_resource_group" "adrien" {
  name     = var.resource_group_name
  location = var.location
}

resource "azurerm_virtual_network" "adrien" {
  name                = "adrien-network"
  location            = var.location
  resource_group_name = azurerm_resource_group.adrien.name
  address_space       = ["10.0.0.0/16"]
}

resource "azurerm_subnet" "adrien" {
  name                 = "adrien-subnet"
  resource_group_name  = azurerm_resource_group.adrien.name
  virtual_network_name = azurerm_virtual_network.adrien.name
  address_prefixes     = ["10.0.1.0/24"]
}

resource "azurerm_public_ip" "adrien" {
  name                = "adrien-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.adrien.name
  allocation_method   = "Static"
}

resource "azurerm_network_interface" "adrien" {
  name                = "adrien-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.adrien.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.adrien.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.adrien.id
  }
}

resource "azurerm_linux_virtual_machine" "adrien" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.adrien.name
  location            = var.location
  size                = var.vm_size
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    azurerm_network_interface.adrien.id,
  ]

  os_disk {
    name              = "adrien-os-disk"
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }

  disable_password_authentication = false

  tags = {
    environment = "dev"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y python3-pip python3-dev git",
      "git clone https://github.com/AdrienHouede/InfonuagiqueTerraform.git /home/adrien/InfonuagiqueTerraform",
      "cd /home/adrien/InfonuagiqueTerraform && pip3 install -r requirements.txt",
      "nohup python3 /home/adrien/InfonuagiqueTerraform/main.py &"
    ]
  }
  
}


resource "azurerm_storage_account" "adrien" {
  name                     = "adrienstorageacct"
  resource_group_name      = azurerm_resource_group.adrien.name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

resource "azurerm_storage_container" "adrien" {
  name                  = "statics"
  storage_account_name  = azurerm_storage_account.adrien.name
  container_access_type = "private"
}

output "public_ip" {
  value = azurerm_public_ip.adrien.ip_address
}

resource "azurerm_network_security_group" "adrien" {
  name                = "adrien-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.adrien.name

  security_rule {
    name                       = "Allow-HTTP"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-SSH"
    priority                   = 2000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "Allow-Flask"
    priority                   = 3000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "5000"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}

resource "azurerm_network_interface_security_group_association" "adrien" {
  network_interface_id      = azurerm_network_interface.adrien.id
  network_security_group_id = azurerm_network_security_group.adrien.id
}

variable "account_key" {
  description = "Le clé d'accès du compte Azure Storage"
  type        = string
  sensitive   = true
}