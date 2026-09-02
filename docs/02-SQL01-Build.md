# SQL01 Deployment Guide

## Objective

Deploy SQL Server Express and EmployeeDB.

Server:

```text
SQL01
192.168.100.20
```

---

# Create VM

```powershell
New-VM `
-Name SQL01 `
-MemoryStartupBytes 4GB `
-NewVHDPath "C:\VMs\SQL01.vhdx" `
-NewVHDSizeBytes 60GB `
-Generation 1 `
-SwitchName LabSwitch
```

Purpose:

- Creates SQL01 VM

---

# Configure CPU

```powershell
Set-VMProcessor SQL01 -Count 2
```

Purpose:

- Assigns 2 vCPUs

---

# Configure Static IP

```powershell
New-NetIPAddress `
-InterfaceAlias Ethernet `
-IPAddress 192.168.100.20 `
-PrefixLength 24 `
-DefaultGateway 192.168.100.1
```

Purpose:

- Permanent SQL01 address

---

# Configure DNS

```powershell
Set-DnsClientServerAddress `
-InterfaceAlias Ethernet `
-ServerAddresses 8.8.8.8,1.1.1.1
```

Purpose:

- Internet name resolution

---

# Install SQL Express

Installer:

```text
SQL2022-SSEI-Expr.exe
```

Configuration:

```text
Basic
Instance:
SQLEXPRESS
```

---

# Create Employee Database

```sql
CREATE DATABASE EmployeeDB;
GO
```

---

# Create Table

```sql
CREATE TABLE Employees
(
    Id INT PRIMARY KEY,
    Name VARCHAR(100),
    Department VARCHAR(100),
    Salary DECIMAL(10,2)
);
GO
```

---

# Insert Data

```sql
INSERT INTO Employees VALUES
(1,'Rajesh','Cloud',50000),
(2,'Amit','Support',35000),
(3,'Neha','HR',45000),
(4,'Priya','DevOps',60000);
GO
```

---

# Enable TCP

```text
SQL Server Network Configuration
→ Protocols for SQLEXPRESS
→ TCP/IP Enabled
```

---

# Open Firewall

```powershell
New-NetFirewallRule `
-DisplayName "SQL Server 1433" `
-Direction Inbound `
-Protocol TCP `
-LocalPort 1433 `
-Action Allow
```
