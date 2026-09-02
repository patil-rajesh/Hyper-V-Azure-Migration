# WEB01 Deployment Guide

## Objective

Deploy IIS and EmployeePortal.

Server:

```text
WEB01
192.168.100.10
```

---

# Create VM

```powershell
New-VM `
-Name WEB01 `
-MemoryStartupBytes 4GB `
-NewVHDPath "C:\VMs\WEB01.vhdx" `
-NewVHDSizeBytes 40GB `
-Generation 1 `
-SwitchName LabSwitch
```

---

# Configure IP

```powershell
New-NetIPAddress `
-IPAddress 192.168.100.10 `
-PrefixLength 24 `
-DefaultGateway 192.168.100.1 `
-InterfaceAlias Ethernet
```

---

# DNS

```powershell
Set-DnsClientServerAddress `
-InterfaceAlias Ethernet `
-ServerAddresses 8.8.8.8,1.1.1.1
```

---

# Verify SQL Connectivity

```powershell
ping 192.168.100.20
```

Expected:

```text
Reply received
```

---

# Install IIS

```powershell
Install-WindowsFeature Web-Server `
-IncludeManagementTools
```

---

# Install ASP.NET

```powershell
Install-WindowsFeature Web-Asp-Net45

Install-WindowsFeature NET-Framework-45-Core
```

---

# Create Application Folder

```powershell
mkdir C:\inetpub\wwwroot\EmployeePortal
```

---

# Create Website

```powershell
New-Website `
-Name EmployeePortal `
-Port 8080 `
-PhysicalPath "C:\inetpub\wwwroot\EmployeePortal"
```

---

# SQL Connection String

Before migration:

```csharp
Server=192.168.100.20,1433;
Database=EmployeeDB;
User ID=WebUser;
Password=Password@123;
```

After migration:

```csharp
Server=10.10.1.4,1433;
Database=EmployeeDB;
User ID=WebUser;
Password=Password@123;
```

---

# Restart IIS

```powershell
iisreset
```
