terraform {
  required_providers {
    azurerm = {
      source  = "azurerm"
      version = "4.80.0"
    }
  }
}
provider "azurerm" {
  features {}
}
resource "azurerm_resource_group" "res-0" {
  location   = "centralindia"
  managed_by = ""
  name       = "Hyper-V-Lab"
  tags       = {}
}
resource "azurerm_windows_virtual_machine" "res-1" {
  admin_password                                         = "" # Masked sensitive attribute
  admin_username                                         = "azureuser"
  allow_extension_operations                             = true
  automatic_updates_enabled                              = true
  availability_set_id                                    = ""
  bypass_platform_safety_checks_on_user_schedule_enabled = false
  capacity_reservation_group_id                          = ""
  computer_name                                          = "VM-Hyper-V"
  custom_data                                            = "" # Masked sensitive attribute
  dedicated_host_group_id                                = ""
  dedicated_host_id                                      = ""
  disk_controller_type                                   = "SCSI"
  edge_zone                                              = ""
  enable_automatic_updates                               = true
  encryption_at_host_enabled                             = false
  eviction_policy                                        = ""
  extensions_time_budget                                 = "PT1H30M"
  hotpatching_enabled                                    = false
  license_type                                           = ""
  location                                               = "centralindia"
  max_bid_price                                          = -1
  name                                                   = "VM-Hyper-V"
  network_interface_ids                                  = [azurerm_network_interface.res-3.id]
  os_managed_disk_id                                     = "/subscriptions/940a01c7-1bff-45b6-a29a-688a2dcfcf1a/resourceGroups/HYPER-V-LAB/providers/Microsoft.Compute/disks/VM-Hyper-V_OsDisk_1_1c9dcb0e30c943549895ed6924959e63"
  patch_assessment_mode                                  = "ImageDefault"
  patch_mode                                             = "AutomaticByOS"
  platform_fault_domain                                  = -1
  priority                                               = "Regular"
  provision_vm_agent                                     = true
  proximity_placement_group_id                           = ""
  reboot_setting                                         = ""
  resource_group_name                                    = azurerm_resource_group.res-0.name
  secure_boot_enabled                                    = false
  size                                                   = "Standard_D4s_v4"
  source_image_id                                        = ""
  tags                                                   = {}
  timezone                                               = ""
  user_data                                              = ""
  virtual_machine_scale_set_id                           = ""
  vm_agent_platform_updates_enabled                      = true
  vtpm_enabled                                           = false
  zone                                                   = ""
  additional_capabilities {
    hibernation_enabled = false
    ultra_ssd_enabled   = false
  }
  boot_diagnostics {
    storage_account_uri = ""
  }
  os_disk {
    caching                          = "ReadWrite"
    disk_encryption_set_id           = ""
    disk_size_gb                     = 127
    name                             = "VM-Hyper-V_OsDisk_1_1c9dcb0e30c943549895ed6924959e63"
    secure_vm_disk_encryption_set_id = ""
    security_encryption_type         = ""
    storage_account_type             = "StandardSSD_LRS"
    write_accelerator_enabled        = false
  }
  source_image_reference {
    offer     = "windowsserver2022"
    publisher = "microsoftwindowsserver"
    sku       = "2022-datacenter-azure-edition"
    version   = "latest"
  }
}
resource "azurerm_dev_test_global_vm_shutdown_schedule" "res-2" {
  daily_recurrence_time = "2000"
  enabled               = true
  location              = "centralindia"
  tags                  = {}
  timezone              = "India Standard Time"
  virtual_machine_id    = azurerm_windows_virtual_machine.res-1.id
  notification_settings {
    email           = "rajeshpatilboss@gmail.com"
    enabled         = true
    time_in_minutes = 30
    webhook_url     = ""
  }
}
resource "azurerm_network_interface" "res-3" {
  accelerated_networking_enabled = false
  auxiliary_mode                 = ""
  auxiliary_sku                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  internal_dns_name_label        = ""
  ip_forwarding_enabled          = false
  location                       = "centralindia"
  name                           = "vm-hyper-v135"
  resource_group_name            = azurerm_resource_group.res-0.name
  tags                           = {}
  ip_configuration {
    gateway_load_balancer_frontend_ip_configuration_id = ""
    name                                               = "ipconfig1"
    primary                                            = true
    private_ip_address                                 = "10.0.1.4"
    private_ip_address_allocation                      = "Dynamic"
    private_ip_address_version                         = "IPv4"
    public_ip_address_id                               = azurerm_public_ip.res-8.id
    subnet_id                                          = azurerm_subnet.res-10.id
  }
}
resource "azurerm_network_interface_security_group_association" "res-4" {
  network_interface_id      = azurerm_network_interface.res-3.id
  network_security_group_id = azurerm_network_security_group.res-5.id
}
resource "azurerm_network_security_group" "res-5" {
  location            = "centralindia"
  name                = "VM-Hyper-V-nsg"
  resource_group_name = azurerm_resource_group.res-0.name
  security_rule = [{
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "*"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "3389"
    destination_port_ranges                    = []
    direction                                  = "Inbound"
    name                                       = "RDP"
    priority                                   = 300
    protocol                                   = "Tcp"
    source_address_prefix                      = "*"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
    }, {
    access                                     = "Allow"
    description                                = ""
    destination_address_prefix                 = "*"
    destination_address_prefixes               = []
    destination_application_security_group_ids = []
    destination_port_range                     = "80"
    destination_port_ranges                    = []
    direction                                  = "Inbound"
    name                                       = "Allow-HTTP"
    priority                                   = 310
    protocol                                   = "Tcp"
    source_address_prefix                      = "*"
    source_address_prefixes                    = []
    source_application_security_group_ids      = []
    source_port_range                          = "*"
    source_port_ranges                         = []
  }]
  tags = {}
}
resource "azurerm_network_security_rule" "res-6" {
  access                                     = "Allow"
  description                                = ""
  destination_address_prefix                 = "*"
  destination_address_prefixes               = []
  destination_application_security_group_ids = []
  destination_port_range                     = "80"
  destination_port_ranges                    = []
  direction                                  = "Inbound"
  name                                       = "Allow-HTTP"
  network_security_group_name                = "VM-Hyper-V-nsg"
  priority                                   = 310
  protocol                                   = "Tcp"
  resource_group_name                        = azurerm_resource_group.res-0.name
  source_address_prefix                      = "*"
  source_address_prefixes                    = []
  source_application_security_group_ids      = []
  source_port_range                          = "*"
  source_port_ranges                         = []
  depends_on = [
    azurerm_network_security_group.res-5,
  ]
}
resource "azurerm_network_security_rule" "res-7" {
  access                                     = "Allow"
  description                                = ""
  destination_address_prefix                 = "*"
  destination_address_prefixes               = []
  destination_application_security_group_ids = []
  destination_port_range                     = "3389"
  destination_port_ranges                    = []
  direction                                  = "Inbound"
  name                                       = "RDP"
  network_security_group_name                = "VM-Hyper-V-nsg"
  priority                                   = 300
  protocol                                   = "Tcp"
  resource_group_name                        = azurerm_resource_group.res-0.name
  source_address_prefix                      = "*"
  source_address_prefixes                    = []
  source_application_security_group_ids      = []
  source_port_range                          = "*"
  source_port_ranges                         = []
  depends_on = [
    azurerm_network_security_group.res-5,
  ]
}
resource "azurerm_public_ip" "res-8" {
  allocation_method       = "Static"
  ddos_protection_mode    = "VirtualNetworkInherited"
  domain_name_label       = "rajesh-employees"
  domain_name_label_scope = ""
  edge_zone               = ""
  idle_timeout_in_minutes = 4
  ip_tags                 = {}
  ip_version              = "IPv4"
  location                = "centralindia"
  name                    = "VM-Hyper-V-ip"
  resource_group_name     = azurerm_resource_group.res-0.name
  reverse_fqdn            = ""
  sku                     = "Standard"
  sku_tier                = "Regional"
  tags                    = {}
  zones                   = []
}
resource "azurerm_virtual_network" "res-9" {
  address_space                  = ["10.0.0.0/16"]
  bgp_community                  = ""
  dns_servers                    = []
  edge_zone                      = ""
  flow_timeout_in_minutes        = 0
  location                       = "centralindia"
  name                           = "Vnet-Hyper-V"
  private_endpoint_vnet_policies = "Disabled"
  resource_group_name            = azurerm_resource_group.res-0.name
  subnet = [{
    address_prefixes                              = ["10.0.1.0/24"]
    default_outbound_access_enabled               = false
    delegation                                    = []
    id                                            = "/subscriptions/940a01c7-1bff-45b6-a29a-688a2dcfcf1a/resourceGroups/Hyper-V-Lab/providers/Microsoft.Network/virtualNetworks/Vnet-Hyper-V/subnets/subnet-Hyper-V"
    name                                          = "subnet-Hyper-V"
    private_endpoint_network_policies             = "Disabled"
    private_link_service_network_policies_enabled = true
    route_table_id                                = ""
    security_group                                = ""
    service_endpoint_policy_ids                   = []
    service_endpoints                             = []
  }]
  tags = {}
}
resource "azurerm_subnet" "res-10" {
  address_prefixes                              = ["10.0.1.0/24"]
  default_outbound_access_enabled               = false
  name                                          = "subnet-Hyper-V"
  private_endpoint_network_policies             = "Disabled"
  private_link_service_network_policies_enabled = true
  resource_group_name                           = azurerm_resource_group.res-0.name
  service_endpoint_policy_ids                   = []
  service_endpoints                             = []
  sharing_scope                                 = ""
  virtual_network_name                          = "Vnet-Hyper-V"
  depends_on = [
    azurerm_virtual_network.res-9,
  ]
}
resource "azurerm_recovery_services_vault" "res-11" {
  classic_vmware_replication_enabled = false
  cross_region_restore_enabled       = false
  immutability                       = "Disabled"
  location                           = "centralindia"
  name                               = "vault-mtbja6d5"
  public_network_access_enabled      = true
  resource_group_name                = azurerm_resource_group.res-0.name
  sku                                = "RS0"
  soft_delete_enabled                = true
  storage_mode_type                  = "GeoRedundant"
  tags                               = {}
}
resource "azurerm_backup_policy_file_share" "res-12" {
  backup_tier                = "snapshot"
  name                       = "DailyPolicy-mtbja6g2"
  recovery_vault_name        = "vault-mtbja6d5"
  resource_group_name        = azurerm_resource_group.res-0.name
  snapshot_retention_in_days = 0
  timezone                   = "UTC"
  backup {
    frequency = "Daily"
    time      = "19:30"
  }
  retention_daily {
    count = 30
  }
  depends_on = [
    azurerm_recovery_services_vault.res-11,
  ]
}
resource "azurerm_backup_policy_vm" "res-13" {
  consistency_type               = ""
  instant_restore_retention_days = 2
  name                           = "DefaultPolicy"
  policy_type                    = "V1"
  recovery_vault_name            = "vault-mtbja6d5"
  resource_group_name            = azurerm_resource_group.res-0.name
  timezone                       = "UTC"
  backup {
    frequency     = "Daily"
    hour_duration = 0
    hour_interval = 0
    time          = "23:00"
    weekdays      = []
  }
  retention_daily {
    count = 30
  }
  depends_on = [
    azurerm_recovery_services_vault.res-11,
  ]
}
resource "azurerm_backup_policy_vm" "res-14" {
  consistency_type               = ""
  instant_restore_retention_days = 2
  name                           = "EnhancedPolicy"
  policy_type                    = "V2"
  recovery_vault_name            = "vault-mtbja6d5"
  resource_group_name            = azurerm_resource_group.res-0.name
  timezone                       = "UTC"
  backup {
    frequency     = "Hourly"
    hour_duration = 12
    hour_interval = 4
    time          = "08:00"
    weekdays      = []
  }
  retention_daily {
    count = 30
  }
  depends_on = [
    azurerm_recovery_services_vault.res-11,
  ]
}
resource "azurerm_backup_policy_vm_workload" "res-15" {
  name                = "HourlyLogBackup"
  recovery_vault_name = "vault-mtbja6d5"
  resource_group_name = azurerm_resource_group.res-0.name
  workload_type       = "SQLDataBase"
  protection_policy {
    policy_type = "Log"
    backup {
      frequency            = ""
      frequency_in_minutes = 60
      time                 = ""
      weekdays             = []
    }
    simple_retention {
      count = 30
    }
  }
  protection_policy {
    policy_type = "Full"
    backup {
      frequency            = "Daily"
      frequency_in_minutes = 0
      time                 = "23:00"
      weekdays             = []
    }
    retention_daily {
      count = 30
    }
  }
  settings {
    compression_enabled = false
    time_zone           = "UTC"
  }
  depends_on = [
    azurerm_recovery_services_vault.res-11,
  ]
}
