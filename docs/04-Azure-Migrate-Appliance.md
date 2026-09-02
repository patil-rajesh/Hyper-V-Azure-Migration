# Azure Migrate Appliance Guide

## Objective

Discover, assess, replicate and migrate Hyper‑V VMs.

Server:

```text
AzureMigrateAppliance
192.168.100.30
```

---

# Configure Static IP

```powershell
New-NetIPAddress `
-IPAddress 192.168.100.30 `
-PrefixLength 24 `
-DefaultGateway 192.168.100.1
```

---

# Configure DNS

```powershell
Set-DnsClientServerAddress `
-ServerAddresses 8.8.8.8,1.1.1.1
```

---

# Verify Connectivity

```powershell
ping 192.168.100.1

ping 8.8.8.8

ping login.microsoftonline.com
```

---

# Configure Trusted Hosts

```powershell
Set-Item `
WSMan:\localhost\Client\TrustedHosts `
-Value * `
-Force

Restart-Service WinRM
```

Purpose:

- Allows appliance to connect to non-domain servers

---

# Verify WinRM

```powershell
Test-WsMan 192.168.100.1

Test-WsMan 192.168.100.10

Test-WsMan 192.168.100.20
```

Expected:

```text
ProductVendor: Microsoft Corporation
```

---

# Discovery Source

```text
Hyper-V Host

192.168.100.1

VM-HYPER-V\azureuser
```

---

# Guest Credentials

WEB01:

```text
win-pnq3fg157s1\administrator
```

SQL01:

```text
win-kairb4seka3\administrator
```

---

# Assessment Settings

```text
Performance Based

95 Percentile

1 Day History

Comfort Factor 1.3

Central India
```

---

# Common Issues

## Error 60001

Cause:

```text
Guest discovery failed
```

Fix:

```powershell
Enable-PSRemoting -Force

Test-WsMan
```

---

## Error 9010

Cause:

```text
VM powered off
```

Fix:

```powershell
Start-VM WEB01

Start-VM SQL01
```

---

## Error 28075

Cause:

```text
No D2as_v5 quota
```

Fix:

```text
Change VM size

D2as_v5

↓

B2s
```

---

# Final Migration

Replication:

```text
WEB01
SQL01
```

Migration Order:

```text
1. SQL01
2. WEB01
```

Result:

```text
Migration Successful
```
# Phase 5 - Appliance Network Configuration

## Configure Static IP

```powershell
New-NetIPAddress `
-InterfaceAlias "Ethernet" `
-IPAddress 192.168.100.30 `
-PrefixLength 24 `
-DefaultGateway 192.168.100.1
```

Purpose:

- Assigns static IP to appliance.

Result:

```text
192.168.100.30
```

---

## Configure DNS

```powershell
Set-DnsClientServerAddress `
-InterfaceAlias "Ethernet" `
-ServerAddresses 8.8.8.8,1.1.1.1
```

Purpose:

- Azure authentication
- Azure Migrate connectivity
- Microsoft endpoint resolution

---

## Verify Appliance Network

```powershell
ipconfig
```

Expected:

```text
IP Address:
192.168.100.30

Gateway:
192.168.100.1

DNS:
8.8.8.8
1.1.1.1
```

---

## Verify Host Connectivity

```powershell
ping 192.168.100.1
```

Expected:

```text
Reply received
```

---

## Verify Internet Connectivity

```powershell
ping 8.8.8.8

ping google.com

ping login.microsoftonline.com
```

Expected:

```text
Reply received
```

---

# Phase 6 - Azure Connectivity Validation

```powershell
Test-NetConnection `
login.microsoftonline.com `
-Port 443
```

```powershell
Test-NetConnection `
management.azure.com `
-Port 443
```

```powershell
Test-NetConnection `
portal.azure.com `
-Port 443
```

Expected:

```text
TcpTestSucceeded : True
```

---

# Phase 7 - Configure TrustedHosts

Required because:

```text
WEB01 and SQL01 are workgroup servers.
```

Configure:

```powershell
Set-Item `
WSMan:\localhost\Client\TrustedHosts `
-Value * `
-Force
```

Verify:

```powershell
Get-Item `
WSMan:\localhost\Client\TrustedHosts
```

Expected:

```text
Value : *
```

Restart WinRM:

```powershell
Restart-Service WinRM
```

---

# Phase 8 - Validate WinRM Communication

## Hyper-V Host

```powershell
Test-WsMan 192.168.100.1
```

Expected:

```text
Microsoft Corporation
```

---

## WEB01

```powershell
Test-WsMan 192.168.100.10
```

Expected:

```text
Microsoft Corporation
```

---

## SQL01

```powershell
Test-WsMan 192.168.100.20
```

Expected:

```text
Microsoft Corporation
```

---

# Phase 9 - Remote Management Validation

## Hyper-V Host

```powershell
$cred = Get-Credential

Enter-PSSession `
-ComputerName 192.168.100.1 `
-Credential $cred
```

Credential:

```text
VM-HYPER-V\azureuser
```

Expected:

```text
[192.168.100.1]: PS C:\>
```

---

## WEB01

```powershell
$cred = Get-Credential

Enter-PSSession `
-ComputerName 192.168.100.10 `
-Credential $cred
```

Credential:

```text
win-pnq3fg157s1\administrator
```

Expected:

```text
[192.168.100.10]: PS C:\>
```

---

## SQL01

```powershell
$cred = Get-Credential

Enter-PSSession `
-ComputerName 192.168.100.20 `
-Credential $cred
```

Credential:

```text
win-kairb4seka3\administrator
```

Expected:

```text
[192.168.100.20]: PS C:\>
```

---

# Phase 10 - Hyper-V Discovery Validation

Run on HVHOST01:

```powershell
Get-VMNetworkAdapter `
-VMName WEB01 |
Select VMName,IPAddresses
```

```powershell
Get-VMNetworkAdapter `
-VMName SQL01 |
Select VMName,IPAddresses
```

Expected:

```text
WEB01
192.168.100.10

SQL01
192.168.100.20
```

Purpose:

- Fixes Azure Migrate Error 60001.

---

# Phase 11 - Azure Migrate Discovery

Add Hyper-V source:

```text
Source:
Hyper-V Host

IP:
192.168.100.1
```

Credential:

```text
VM-HYPER-V\azureuser
```

Status:

```text
Validation Successful
```

---

# Phase 12 - Guest Discovery Credentials

WEB01

```text
Credential Type:
Windows (Non-domain)

Username:
win-pnq3fg157s1\administrator
```

---

SQL01

```text
Credential Type:
Windows (Non-domain)

Username:
win-kairb4seka3\administrator
```

---

# Phase 13 - Discovery Results

Discovered:

```text
WEB01
SQL01
AzureMigrateAppliance
```

Applications:

```text
EmployeePortal
Default Web Site
```

Databases:

```text
SQLEXPRESS
EmployeeDB
```

---

# Phase 14 - Error Resolution

## Error 60001

Cause:

```text
IP addresses not discovered.
```

Fix:

```powershell
Get-VMNetworkAdapter `
-VMName WEB01

Get-VMNetworkAdapter `
-VMName SQL01
```

Enable:

```powershell
Enable-PSRemoting -Force
```

Configure:

```powershell
TrustedHosts = *
```

---

## Error 9010

Cause:

```text
VM not powered on.
```

Fix:

```powershell
Start-VM WEB01

Start-VM SQL01
```

---

## Error 28075

Cause:

```text
D2as_v5 quota unavailable.
```

Fix:

```text
Change:
Standard_D2as_v5

To:
Standard_B2s
```
