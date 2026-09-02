# Hyper-V Host Deployment Guide

## Objective

Create a nested Hyper‑V environment inside an Azure VM.

Server:

```text
VM-HYPER-V
192.168.100.1
```

---

# Install Hyper-V

```powershell
Install-WindowsFeature Hyper-V -IncludeManagementTools -Restart
```

Purpose:

- Installs Hyper‑V role
- Installs Hyper‑V Manager
- Installs PowerShell modules

Verify:

```powershell
Get-WindowsFeature Hyper-V
```

Expected:

```text
Installed
```

---

# Load Hyper-V Module

```powershell
Import-Module Hyper-V
```

Purpose:

- Loads Hyper‑V PowerShell commands

Verify:

```powershell
Get-Command -Module Hyper-V
```

---

# Create Lab Network

```powershell
New-VMSwitch `
-Name "LabSwitch" `
-SwitchType Internal
```

Purpose:

- Creates isolated network
- Connects WEB01, SQL01 and Appliance

Verify:

```powershell
Get-VMSwitch
```

---

# Configure Hyper-V Host Address

```powershell
New-NetIPAddress `
-IPAddress 192.168.100.1 `
-PrefixLength 24 `
-InterfaceAlias "vEthernet (LabSwitch)"
```

Purpose:

- Creates gateway for nested VMs

Result:

```text
192.168.100.1
```

---

# Configure Internet Sharing

```powershell
New-NetNat `
-Name LabNAT `
-InternalIPInterfaceAddressPrefix 192.168.100.0/24
```

Purpose:

- Gives WEB01 and SQL01 Internet access

Verify:

```powershell
Get-NetNat
```

---

# Create VM Storage

```powershell
mkdir C:\VMs

mkdir C:\ISO
```

Purpose:

- Stores VM disks
- Stores ISO files
