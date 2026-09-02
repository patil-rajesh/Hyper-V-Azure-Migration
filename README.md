
# End-to-End Hyper‑V to Azure Migration Lab Using Azure Migrate

## Project Overview

This project demonstrates an end-to-end migration of a two-tier application from a nested Hyper‑V environment to Microsoft Azure using Azure Migrate.

The lab includes:

- Hyper‑V Host (HVHOST01)
- WEB01 (IIS Web Server)
- SQL01 (SQL Server Express)
- Azure Migrate Appliance
- Azure Migrate Discovery
- Azure VM Assessment
- Wave Planning
- Azure Site Recovery Replication
- Migration Execution
- Post-Migration Application Validation

---

# Architecture

## Source Environment

```text
192.168.100.0/24

                    HVHOST01
                 192.168.100.1
                        │
                 Internal vSwitch
                        │
        ┌───────────────┴───────────────┐
        │                               │

     WEB01                         SQL01
192.168.100.10                192.168.100.20

 IIS Website                    SQL Express
 EmployeePortal                 EmployeeDB

        │
        │
 Azure Migrate Appliance
     192.168.100.30
```

---

## Target Azure Environment

```text
Azure Subscription

    Resource Group
    Hyper-V-Migrated

           │

    migration-vnet
      10.10.0.0/16

           │

      10.10.1.0/24

      ┌──────────────┐
      │              │

    WEB01         SQL01

10.10.1.5      10.10.1.4

Public IP:
20.197.60.73

EmployeePortal
```

---

# Prerequisites

## Azure

- Azure Subscription
- Azure Migrate Project
- Resource Group
- Contributor Permissions

## Hyper‑V Software

- Windows Server 2022
- Hyper‑V Role
- Hyper‑V Manager

## VM Images

- Windows Server 2022 ISO
- SQL Server Express Installer

---

# Phase 1 – Hyper‑V Environment Deployment

## Install Hyper‑V

Run on HVHOST01:

```powershell
Install-WindowsFeature Hyper-V `
-IncludeManagementTools `
-Restart
```

---

## Create Virtual Switch

```powershell
New-VMSwitch `
-Name "LabSwitch" `
-SwitchType Internal
```

---

## Configure Host Network

```powershell
New-NetIPAddress `
-InterfaceAlias "vEthernet (LabSwitch)" `
-IPAddress 192.168.100.1 `
-PrefixLength 24
```

---

# Phase 2 – Create WEB01

## Create VM

```powershell
New-VM `
-Name WEB01 `
-MemoryStartupBytes 2GB `
-Generation 2
```

Attach:

```text
Windows Server 2022 ISO
```

Install Windows.

---

## Configure Network

```powershell
New-NetIPAddress `
-IPAddress 192.168.100.10 `
-PrefixLength 24 `
-DefaultGateway 192.168.100.1 `
-InterfaceAlias Ethernet

Set-DnsClientServerAddress `
-InterfaceAlias Ethernet `
-ServerAddresses 8.8.8.8,1.1.1.1
```

---

## Install IIS

```powershell
Install-WindowsFeature `
Web-Server `
-IncludeManagementTools
```

Verify:

```powershell
iisreset
```

---

# Phase 3 – Create SQL01

## Create VM

```powershell
New-VM `
-Name SQL01 `
-MemoryStartupBytes 4GB `
-Generation 2
```

Attach:

```text
Windows Server 2022 ISO
```

Install Windows.

---

## Configure Network

```powershell
New-NetIPAddress `
-IPAddress 192.168.100.20 `
-PrefixLength 24 `
-DefaultGateway 192.168.100.1 `
-InterfaceAlias Ethernet
```

---

## Install SQL Express

```cmd
SQLEXPR_x64_ENU.exe
```

Instance:

```text
SQLEXPRESS
```

---

## Create Database

```sql
CREATE DATABASE EmployeeDB;
GO
```

Create table:

```sql
CREATE TABLE Employees
(
    Id INT PRIMARY KEY,
    Name NVARCHAR(100),
    Department NVARCHAR(100),
    Salary MONEY
);
```

Insert sample records.

---

# Phase 4 – Deploy Employee Portal

## Folder Structure

```text
C:\inetpub\wwwroot\EmployeePortal
```

## Application

```text
Employees.aspx
```

Connection string:

```csharp
Server=192.168.100.20,1433;
Database=EmployeeDB;
User ID=WebUser;
Password=password@123;
TrustServerCertificate=True;
```

---

# Phase 5 – Configure WinRM

## WEB01

```powershell
winrm quickconfig

Enable-PSRemoting -Force

Set-Service WinRM -StartupType Automatic

Start-Service WinRM

Enable-NetFirewallRule `
-DisplayGroup "Windows Remote Management"
```

---

## SQL01

```powershell
winrm quickconfig

Enable-PSRemoting -Force

Set-Service WinRM -StartupType Automatic

Start-Service WinRM

Enable-NetFirewallRule `
-DisplayGroup "Windows Remote Management"
```

---

# Phase 6 – Deploy Azure Migrate Appliance

Deploy appliance OVA/VHD.

## Configure Network

```text
IP Address:
192.168.100.30

Gateway:
192.168.100.1

DNS:
8.8.8.8
1.1.1.1
```

Verify:

```powershell
ping 192.168.100.1

ping 8.8.8.8
```

---

## Configure TrustedHosts

```powershell
Set-Item `
WSMan:\localhost\Client\TrustedHosts `
-Value * `
-Force

Restart-Service WinRM
```

---

# Phase 7 – Discovery

## Add Hyper‑V Source

```text
Source:
Hyper‑V Host

IP:
192.168.100.1

Credential:
VM-HYPER-V\azureuser
```

---

## Guest Credentials

### WEB01

```text
win-pnq3fg157s1\administrator
```

### SQL01

```text
win-kairb4seka3\administrator
```

---

## Validation

```powershell
Test-WsMan 192.168.100.10

Test-WsMan 192.168.100.20
```

Expected:

```text
Success
```

---

# Phase 8 – Discovery Results

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

SQL:

```text
SQLExpress
```

---

# Phase 9 – Assessment

Assessment Type:

```text
Azure VM
```

Configuration:

```text
Performance Based

Performance History:
1 Day

Percentile:
95

Comfort Factor:
1.3

Region:
Central India
```

---

# Assessment Result

Azure Readiness:

```text
100%
```

Recommended:

```text
Standard_D2as_v5
```

Estimated Cost:

```text
$174/month
```

---

# Phase 10 – Wave Planning

Generated Wave:

```text
Wave 1
```

Workloads:

```text
WEB01
SQL01
EmployeePortal
SQLExpress
```

Strategy:

```text
Lift and Shift
```

---

# Phase 11 – Server Migration

## Configure Server Migration

Select:

```text
Servers or Virtual Machines
```

Target:

```text
Azure VM
```

Virtualized:

```text
Yes, with Hyper‑V
```

---

## Install Site Recovery Provider

On HVHOST01:

```text
AzureSiteRecoveryProvider.exe
```

Register:

```text
VaultCredentials.vaultcredentials
```

---

# Phase 12 – Replication

Replicate:

```text
WEB01
SQL01
```

Region:

```text
Central India
```

Resource Group:

```text
Hyper-V-Migrated
```

---

## Azure Network

```text
migration-vnet
```

Address Space:

```text
10.10.0.0/16
```

Subnet:

```text
10.10.1.0/24
```

---

## Compute

Final VM Size:

```text
Standard_B2s
```

Reason:

```text
DASv5 quota unavailable.
```

---

# Phase 13 – Migration

## SQL01

Migration:

```text
Planned Failover
```

Status:

```text
Successful
```

---

## WEB01

Migration:

```text
Planned Failover
```

Status:

```text
Successful
```

---

# Phase 14 – Azure Networking

## WEB01

```text
Private IP:
10.10.1.5

Public IP:
20.197.60.73
```

---

## SQL01

```text
Private IP:
10.10.1.4
```

---

# NSG Rules

## WEB01

```text
TCP 80
TCP 443
TCP 3389
```

---

## SQL01

```text
TCP 1433
TCP 3389
```

---

# Phase 15 – Post Migration Fix

## Problem

Application failed:

```text
SQL timeout
```

Cause:

```csharp
Server=192.168.100.20
```

Old SQL address.

---

## Fix

Update:

```csharp
Server=10.10.1.4
```

Run:

```powershell
iisreset
```

---

# Validation

Test SQL Connectivity:

```powershell
Test-NetConnection 10.10.1.4 -Port 1433
```

Result:

```text
TcpTestSucceeded : True
```

---

# Final URLs

Main IIS Site:

```text
http://20.197.60.73
```

Employee Portal:

```text
http://20.197.60.73/EmployeePortal
```

Employee Portal Data Page:

```text
http://20.197.60.73/EmployeePortal/Employees.aspx
```

---

# Migration Issues Encountered

## Error 60001

```text
Unable to connect to server
```

### Resolution

```text
Enabled WinRM
Configured TrustedHosts
Validated PSSession
```

---

## Error 9010

```text
VM Not Powered On
```

### Resolution

```text
Started WEB01
Started SQL01
```

---

## Error 28075

```text
Core Count Limit Reached
```

### Resolution

```text
Changed VM Size

Standard_D2as_v5
↓

Standard_B2s
```

---

# Project Outcome

✅ Hyper‑V Environment Deployed

✅ Azure Migrate Appliance Created

✅ Discovery Successful

✅ Assessment Successful

✅ Wave Planning Successful

✅ Replication Successful

✅ Migration Successful

✅ Application Functional

✅ SQL Connectivity Restored

✅ Employee Portal Accessible From Azure

---

# Skills Demonstrated

- Hyper‑V
- Windows Server 2022
- IIS
- SQL Server Express
- Azure Migrate
- Azure Site Recovery
- Azure Virtual Machines
- Azure Networking
- NSG Management
- Azure VM Assessment
- Lift-and-Shift Migration
- Disaster Recovery
- PowerShell Automation
- Infrastructure as Code
