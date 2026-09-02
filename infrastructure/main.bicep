param virtualMachines_VM_Hyper_V_name string = 'VM-Hyper-V'
param virtualNetworks_Vnet_Hyper_V_name string = 'Vnet-Hyper-V'
param networkInterfaces_vm_hyper_v135_name string = 'vm-hyper-v135'
param publicIPAddresses_VM_Hyper_V_ip_name string = 'VM-Hyper-V-ip'
param networkSecurityGroups_VM_Hyper_V_nsg_name string = 'VM-Hyper-V-nsg'
param schedules_shutdown_computevm_vm_hyper_v_name string = 'shutdown-computevm-vm-hyper-v'

resource networkSecurityGroups_VM_Hyper_V_nsg_name_resource 'Microsoft.Network/networkSecurityGroups@2025-07-01' = {
  name: networkSecurityGroups_VM_Hyper_V_nsg_name
  location: 'centralindia'
  properties: {
    securityRules: [
      {
        name: 'RDP'
        id: networkSecurityGroups_VM_Hyper_V_nsg_name_RDP.id
        properties: {
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 300
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
      {
        name: 'Allow-HTTP'
        id: networkSecurityGroups_VM_Hyper_V_nsg_name_Allow_HTTP.id
        properties: {
          protocol: 'TCP'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 310
          direction: 'Inbound'
          sourcePortRanges: []
          destinationPortRanges: []
          sourceAddressPrefixes: []
          destinationAddressPrefixes: []
        }
      }
    ]
  }
}

resource publicIPAddresses_VM_Hyper_V_ip_name_resource 'Microsoft.Network/publicIPAddresses@2025-07-01' = {
  name: publicIPAddresses_VM_Hyper_V_ip_name
  location: 'centralindia'
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    ipAddress: '52.172.150.13'
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
    dnsSettings: {
      domainNameLabel: 'rajesh-employees'
      fqdn: 'rajesh-employees.centralindia.cloudapp.azure.com'
    }
    ipTags: []
    ddosSettings: {
      protectionMode: 'VirtualNetworkInherited'
    }
  }
}

resource virtualNetworks_Vnet_Hyper_V_name_resource 'Microsoft.Network/virtualNetworks@2025-07-01' = {
  name: virtualNetworks_Vnet_Hyper_V_name
  location: 'centralindia'
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    encryption: {
      enabled: false
      enforcement: 'AllowUnencrypted'
    }
    privateEndpointVNetPolicies: 'Disabled'
    subnets: [
      {
        name: 'subnet-Hyper-V'
        id: virtualNetworks_Vnet_Hyper_V_name_subnet_Hyper_V.id
        properties: {
          addressPrefixes: [
            '10.0.1.0/24'
          ]
          delegations: []
          privateEndpointNetworkPolicies: 'Disabled'
          privateLinkServiceNetworkPolicies: 'Enabled'
          defaultOutboundAccess: false
        }
      }
    ]
    virtualNetworkPeerings: []
    enableDdosProtection: false
  }
}

resource virtualMachines_VM_Hyper_V_name_resource 'Microsoft.Compute/virtualMachines@2026-03-01' = {
  name: virtualMachines_VM_Hyper_V_name
  location: 'centralindia'
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_D4s_v4'
    }
    additionalCapabilities: {
      hibernationEnabled: false
    }
    storageProfile: {
      imageReference: {
        publisher: 'microsoftwindowsserver'
        offer: 'windowsserver2022'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        osType: 'Windows'
        name: '${virtualMachines_VM_Hyper_V_name}_OsDisk_1_1c9dcb0e30c943549895ed6924959e63'
        createOption: 'FromImage'
        caching: 'ReadWrite'
        managedDisk: {
          id: resourceId(
            'Microsoft.Compute/disks',
            '${virtualMachines_VM_Hyper_V_name}_OsDisk_1_1c9dcb0e30c943549895ed6924959e63'
          )
        }
        deleteOption: 'Delete'
      }
      dataDisks: []
      diskControllerType: 'SCSI'
    }
    osProfile: {
      computerName: virtualMachines_VM_Hyper_V_name
      windowsConfiguration: {
        provisionVMAgent: true
        enableAutomaticUpdates: true
        patchSettings: {
          patchMode: 'AutomaticByOS'
          assessmentMode: 'ImageDefault'
          enableHotpatching: false
        }
      }
      secrets: []
      allowExtensionOperations: true
      requireGuestProvisionSignal: true
      adminUsername: 'azureuser'
    }
    securityProfile: {
      securityType: 'Standard'
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: networkInterfaces_vm_hyper_v135_name_resource.id
          properties: {
            deleteOption: 'Detach'
          }
        }
      ]
    }
    diagnosticsProfile: {
      bootDiagnostics: {
        enabled: true
      }
    }
  }
}

resource schedules_shutdown_computevm_vm_hyper_v_name_resource 'microsoft.devtestlab/schedules@2018-09-15' = {
  name: schedules_shutdown_computevm_vm_hyper_v_name
  location: 'centralindia'
  properties: {
    status: 'Enabled'
    taskType: 'ComputeVmShutdownTask'
    dailyRecurrence: {
      time: '2000'
    }
    timeZoneId: 'India Standard Time'
    notificationSettings: {
      status: 'Enabled'
      timeInMinutes: 30
      emailRecipient: 'rajeshpatilboss@gmail.com'
      notificationLocale: 'en'
    }
    targetResourceId: virtualMachines_VM_Hyper_V_name_resource.id
  }
}

resource networkSecurityGroups_VM_Hyper_V_nsg_name_Allow_HTTP 'Microsoft.Network/networkSecurityGroups/securityRules@2025-07-01' = {
  name: '${networkSecurityGroups_VM_Hyper_V_nsg_name}/Allow-HTTP'
  properties: {
    protocol: 'TCP'
    sourcePortRange: '*'
    destinationPortRange: '80'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 310
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_VM_Hyper_V_nsg_name_resource
  ]
}

resource networkSecurityGroups_VM_Hyper_V_nsg_name_RDP 'Microsoft.Network/networkSecurityGroups/securityRules@2025-07-01' = {
  name: '${networkSecurityGroups_VM_Hyper_V_nsg_name}/RDP'
  properties: {
    protocol: 'Tcp'
    sourcePortRange: '*'
    destinationPortRange: '3389'
    sourceAddressPrefix: '*'
    destinationAddressPrefix: '*'
    access: 'Allow'
    priority: 300
    direction: 'Inbound'
    sourcePortRanges: []
    destinationPortRanges: []
    sourceAddressPrefixes: []
    destinationAddressPrefixes: []
  }
  dependsOn: [
    networkSecurityGroups_VM_Hyper_V_nsg_name_resource
  ]
}

resource virtualNetworks_Vnet_Hyper_V_name_subnet_Hyper_V 'Microsoft.Network/virtualNetworks/subnets@2025-07-01' = {
  name: '${virtualNetworks_Vnet_Hyper_V_name}/subnet-Hyper-V'
  properties: {
    addressPrefixes: [
      '10.0.1.0/24'
    ]
    delegations: []
    privateEndpointNetworkPolicies: 'Disabled'
    privateLinkServiceNetworkPolicies: 'Enabled'
    defaultOutboundAccess: false
  }
  dependsOn: [
    virtualNetworks_Vnet_Hyper_V_name_resource
  ]
}

resource networkInterfaces_vm_hyper_v135_name_resource 'Microsoft.Network/networkInterfaces@2025-07-01' = {
  name: networkInterfaces_vm_hyper_v135_name
  location: 'centralindia'
  kind: 'Regular'
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        id: '${networkInterfaces_vm_hyper_v135_name_resource.id}/ipConfigurations/ipconfig1'
        properties: {
          privateIPAddress: '10.0.1.4'
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIPAddresses_VM_Hyper_V_ip_name_resource.id
            properties: {
              deleteOption: 'Detach'
            }
          }
          subnet: {
            id: virtualNetworks_Vnet_Hyper_V_name_subnet_Hyper_V.id
          }
          primary: true
          privateIPAddressVersion: 'IPv4'
        }
      }
    ]
    dnsSettings: {
      dnsServers: []
    }
    enableAcceleratedNetworking: false
    enableIPForwarding: false
    disableTcpStateTracking: false
    networkSecurityGroup: {
      id: networkSecurityGroups_VM_Hyper_V_nsg_name_resource.id
    }
    nicType: 'Standard'
    auxiliaryMode: 'None'
    auxiliarySku: 'None'
  }
}
