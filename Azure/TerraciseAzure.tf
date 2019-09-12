#initial setup
provider "azurerm" {
    client_id       = "your client id"
    client_secret   = "your client secret"
    subscription_id = "your subscription id"
    tenant_id       = "your tenant id"
}

#set variable
variable "prefix" {
    default = "terra"
}

#setup for Resource Group
resource "azurerm_resource_group" "terra-source" {
    name     = "${var.prefix}-resource"
    location = "your desired location"
}

#setup for Virtual Machine
resource "azurerm_virtual_machine" "terra-vm" {
    depends_on            = ["azurerm_resource_group.terra-source",
                             "azurerm_network_interface.terra-nic"]

    name                  = "${var.prefix}-vm"
    location              = "${azurerm_resource_group.terra-source.location}"
    resource_group_name   = "${azurerm_resource_group.terra-source.name}"
    network_interface_ids = ["${azurerm_network_interface.terra-nic.id}"]
    vm_size               = "Standard_B1s"

    storage_image_reference {
        publisher = "Canonical"
        offer     = "UbuntuServer"
        sku       = "16.04-LTS"
        version   = "latest"
    }

    storage_os_disk {
        name              = "${var.prefix}disk1"
        caching           = "ReadWrite"
        create_option     = "FromImage"
        managed_disk_type = "Standard_LRS"
  }

    os_profile {
        computer_name  = "terrazure"
        admin_username = "yourUsername"
        admin_password = "yourP4s5Word!"
  }

    os_profile_linux_config {
        disable_password_authentication = false
  }
}

#setup for Virtual Network
resource "azurerm_virtual_network" "terra-network" {
    depends_on          = ["azurerm_resource_group.terra-source"]

    name                = "${var.prefix}-network"
    address_space       = ["10.0.0.0/16"]
    location            = "${azurerm_resource_group.terra-source.location}"
    resource_group_name = "${azurerm_resource_group.terra-source.name}"
}

#setup for Subnet
resource "azurerm_subnet" "terra-subnet" {
    depends_on           = ["azurerm_resource_group.terra-source",
                            "azurerm_virtual_network.terra-network"]

    name                 = "${var.prefix}-subnet"
    resource_group_name  = "${azurerm_resource_group.terra-source.name}"
    virtual_network_name = "${azurerm_virtual_network.terra-network.name}"
    address_prefix       = "10.0.2.0/24"
}

#setup for Network Interface
resource "azurerm_network_interface" "terra-nic" {
    depends_on                = ["azurerm_resource_group.terra-source",
                                 "azurerm_network_security_group.terra-netsec-group",
                                 "azurerm_subnet.terra-subnet",
                                 "azurerm_public_ip.terra-public-ip"]

    name                      = "${var.prefix}-nic"
    location                  = "${azurerm_resource_group.terra-source.location}"
    resource_group_name       = "${azurerm_resource_group.terra-source.name}"
    network_security_group_id = "${azurerm_network_security_group.terra-netsec-group.id}"

    ip_configuration {
        name                          = "${var.prefix}-config1"
        subnet_id                     = "${azurerm_subnet.terra-subnet.id}"
        private_ip_address_allocation = "Dynamic"
        public_ip_address_id          = "${azurerm_public_ip.terra-public-ip.id}"
  }
}

#setup for Static Public IP Address
resource "azurerm_public_ip" "terra-public-ip" {
    depends_on          = ["azurerm_resource_group.terra-source"]

    name                = "${var.prefix}-ip"
    location            = "${azurerm_resource_group.terra-source.location}"
    resource_group_name = "${azurerm_resource_group.terra-source.name}"
    allocation_method   = "Static"
    sku                 = "Basic"
    ip_version          = "IPv4"
}

#setup for Network Security Group with rules
resource "azurerm_network_security_group" "terra-netsec-group" {
    depends_on          = ["azurerm_resource_group.terra-source"]

    name                = "${var.prefix}-net-group"
    location            = "${azurerm_resource_group.terra-source.location}"
    resource_group_name = "${azurerm_resource_group.terra-source.name}"

    security_rule {
        name                       = "${var.prefix}-inbound"
        priority                   = 100
        direction                  = "Inbound"
        access                     = "Allow"
        protocol                   = "TCP"
        source_port_range          = "*"
        destination_port_ranges    = ["22","80","443"]
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }

    security_rule {
        name                       = "${var.prefix}-outbound"
        priority                   = 100
        direction                  = "Outbound"
        access                     = "Allow"
        protocol                   = "TCP"
        source_port_range          = "*"
        destination_port_range     = "*"
        source_address_prefix      = "*"
        destination_address_prefix = "*"
    }
}