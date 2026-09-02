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
