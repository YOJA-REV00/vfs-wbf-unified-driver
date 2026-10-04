![Driver Version](https://shields.io)
![Bus Status](https://shields.io)
![Architecture](https://shields.io)
![Project Type](https://shields.io)

# Universal Validity Biometric WBF Driver Pack 🚀

An independent custom laboratory project engineered exclusively for educational, hardware preservation, and low-level driver deployment purposes. This repository contains a universal framework to force-inject and bind an updated Windows Biometric Framework (WBF) driver onto the legacy **Validity Sensors** family embedded across multiple portable hardware ecosystems.

---

## 🔌 Universal Hardware Compatibility Matrix
This unified framework universally targets and features native instruction mapping for the following **5 compatible core Validity chips**:

1. **Validity 451 Series (VFS301):** `USB\VID_138A&PID_0007`
2. **Validity 471 Series (VFS471):** `USB\VID_138A&PID_003C`
3. **Validity 491 Series (VFS491):** `USB\VID_138A&PID_003D`
4. **Validity 495 Series (VFS495):** `USB\VID_138A&PID_003F`
5. **Validity WBF Legacy Core:** `USB\VID_138A&PID_0018`

---

## 📊 Driver Versioning Matrix
* **Original Legacy Base Version:** `4.3.124.0` 
* **Target Package Version (Spoof):** `4.9.532.1` 

The upgrade path forces a progressive rank over legacy baseline branches, ensuring the Windows Plug and Play (PnP) engine updates the kernel stack without rolling back to obsolete device caches [HP4420].

---

## 💎 Functional & Biometric Features
This unaligned deployment package successfully unlocks the lower biometric layers, bringing the following capabilities to legacy silicon:
* **Windows Hello Integration:** Enables the hardware abstraction layer to interact directly with modern Windows Hello 生体認証 (biometric) subsystem profiles.
* **Secure OS Credential Provider Binding:** Links the fingerprint sensor's input streams directly into the Winlogon secure architecture for desktop unlocking.
* **Microsoft WBF Compliance:** Bridges the non-standard hardware infrastructure into a standard Windows Biometric Framework (WBF) topology using the official WBDI communication interface.
* **Exclusive Bus Isolation:** Locks down the target USB port communications dynamically to prevent external interception or side-channel telemetry manipulation during authentication tasks.

---

## ⚡ Technical Automation Features
1. **Automated UAC Self-Escalation:** The core deployment batch script monitors session privileges on execution and implicitly spawns a hidden PowerShell wrapper to auto-elevate itself to Administrator without complex multi-clicking.
2. **Direct Kernel Binding Injection:** Bypasses aggressive OS SetupAPI staging bugs that cause a "driver added but not installed" loop. It forces runtime hardware binding by compiling and executing a native C# call to `newdev.dll::UpdateDriverForPlugAndPlayDevices`.
3. **USB Hot Reload:** Performs a programmatic power-cycle on the root hubs after deployment to force-refresh and validate the new biometric descriptor stack.

---

## 📂 Repository Tree Layout
```text
├── Cert/
│   └── C_MixOS.cer       <-- Laboratory Root Digital Certificate
├── Drivers/
│   └── Driver U/
│       ├── wbf_vfs.inf   <-- Modified unaligned setup layout (v4.9.532.1)
│       ├── wbf_vfs.cat   <-- Lab-certified signature catalog via Inf2Cat
│       └── [Binary Drivers/.sys/.dll dependencies]
└── Instalar_Driver.bat   <-- Master automated execution core
```

---

## 🚀 Lab Deployment Instructions

### Step 1: Trusting the Laboratory Certificate (Mandatory)
Because this package utilizes a custom lab signature to bridge the WBDI communication layers, Windows requires the root certificate to be registered before staging the driver. 

Open an **Administrative PowerShell** console inside the `Cert/` directory and execute the following command to inject **`C_MixOS.cer`**:
```powershell
Import-Certificate -FilePath "C_MixOS.cer" -CertStoreLocation "Cert:\LocalMachine\Root"
```
*Alternatively, you can double-click `C_MixOS.cer`, select **Install Certificate** -> **Local Machine** -> **Place all certificates in the following store** -> Browse -> **Trusted Root Certification Authorities**.*

### Step 2: Running the Master Installer
1. Ensure Test Signing mode is enabled on your Windows environment (`bcdedit /set testsigning on` if required for custom lab test catalogs).
2. Simply double-click **`Instalar_Driver.bat`** using standard privileges.
3. Accept the Windows User Account Control (UAC) prompt to allow the script to self-elevate.
4. On the deployment dashboard, type **`Y`** and press `Enter` to initiate the modular core flash.
5. Check your Windows Device Manager; the sensor should immediately transition to the **Biometric Devices** class running version **4.9.532.1**.

---

### 💻 Reference Lab Staging Node (Auditing Notes)
* **Baseline Test Machine:** HP ProBook 4420s (used as the primary deployment matrix).
* **Reference Processor:** Intel Core i5-560M CPU.
* **Hardware Node Status:** Electrically active and verified as **OK** on the USB southbridge bus.

---

## 📑 Lab Technical Summary & Verification
Running the system verification audit tool inside a local administrative PowerShell terminal reveals the mapping matrix:

```powershell
# Query actual physical bus mapping & Microsoft WBDI Interfacing bindings
Get-PnpDevice -InstanceId 'USB\VID_138A*' | Where-Object { $_.InstanceId -match 'PID_0007|PID_003C|PID_003D|PID_003F|PID_0018' } | Select-Object FriendlyName, Status, Class
```
* **Expected Class Output:** `Biometric` (Instead of default *Unknown USB Device*).
* **Expected Status Output:** `OK`.
* **Active Interfacing GUID:** `{53D29EF7-EE5C-4774-A086-7B568B6070EC}` (WBDI).

---

## ⚖️ Legal Disclaimer
This software bundle is an independent custom laboratory project engineered exclusively for educational and hardware preservation purposes. This project has **NO** affiliation, endorsement, authorization, or sponsorship with the original device manufacturers, Validity Sensors, Inc., or Hewlett-Packard (HP). Use entirely at your own discretion.
