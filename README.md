# Microsoft Office 365 ProPlus - Modular Installer & Activator

[![Platform](https://img.shields.io/badge/Platform-Windows%2010%20%7C%2011-0078D6.svg?logo=windows&logoColor=white)](https://microsoft.com)
[![Architecture](https://img.shields.io/badge/Arch-x86%20%7C%20x64%20%7C%20ARM64-blue.svg)]()
[![ODT Version](https://img.shields.io/badge/Microsoft%20ODT-16.0.17531-informational.svg)]()
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)
[![Author](https://img.shields.io/badge/Author-rony1duet-orange.svg?logo=github)](https://github.com/rony1duet)

A lightweight, automated, and modular deployment tool for **Microsoft Office 365 Professional Plus**. Built upon the official Microsoft Office Deployment Tool (ODT), it allows users to customize app components, choose between 32-bit and 64-bit architectures, install online or create offline deployment packages, and easily activate Office using KMS volume licensing.

---

## ⚡ Quick Start

### 1. Installation
1. Clone or download this repository.
2. Right-click **`Office 365 Setup.cmd`** and select **Run as administrator**.
3. Toggle the desired applications and settings, then press **`[Z]`** to begin.

```text
===========================================================================
 [1] (YES) Microsoft Office Word.
 [2] (YES) Microsoft Office Excel.
 [3] (YES) Microsoft Office PowerPoint.
 [4] (YES) Microsoft Office Outlook.
 [5] (YES) Microsoft Office OneNote.
 [6] (YES) Microsoft Office Publisher
 [7] (YES) Microsoft Office Access.
 [8] (YES) Microsoft Office Visio.
 [9] (YES) Microsoft Office Project.
 [P] (YES) Microsoft Office Proofing Tools.
 [T] (YES) Microsoft Teams.
 [D] (YES) Microsoft OneDrive.
 --- Office will match its language with your Windows system language.
 [B] (64-bit) Here you can switch between a 32-bit or 64-bit installation.
 [O] (NO)  Download Offline Files (x32 & x64 = 6.40 GB).
 [S] (YES) Online Installation.

 --> Toggle your option(s) and toggle [Z] to Start:
===========================================================================
```

### 2. Activation
After installation completes:
1. Right-click **`Office 365 Activator.bat`** and select **Run as administrator**.
2. The script will automatically locate your Office installation, install volume license files, set the KMS client configuration, and connect to available KMS servers to activate.

---

## 📁 Repository Structure

```text
Microsoft-Office-365-ProPlus/
├── Office 365 Setup.cmd      # Interactive CLI installer & XML configuration generator
├── Office 365 Activator.bat  # Automated KMS activation script with multi-server failover
├── setup.exe                 # Official Microsoft Office Deployment Tool (ODT) bootstrapper
├── .gitignore                # Excludes temporary XML configs and downloaded media
└── README.md                 # Complete project documentation
```

---

## ✨ Features

- **Modular Component Selection**: Choose exactly which applications to install. Exclude bloatware like Bing search extensions, Groove, or Skype for Business.
- **Architecture Flexibility**: Automatically detects operating system architecture with safeguard against installing 64-bit on 32-bit machines.
- **Dual Installation Modes**:
  - **Online Installation**: Streams and installs packages on-the-fly directly from Microsoft Content Delivery Network (CDN).
  - **Offline Media Downloader**: Pre-downloads ~6.4 GB installation source files into `.\Office\Data` for air-gapped systems or multi-PC laboratory rollouts.
- **Native Language Matching**: Dynamically configures `MatchOS` to match your Windows display language with seamless fallback to `en-US`.
- **Privacy Enforcement**: Automatically disables Office Customer Experience Improvement Program (telemetry) via registry policy:
  ```cmd
  REG ADD "HKLM\SOFTWARE\Microsoft\Office\Common\ClientTelemetry" /v "DisableTelemetry" /t REG_DWORD /d "00000001" /f
  ```
- **Robust KMS Activation**:
  - Automatically identifies 32-bit and 64-bit installations under `%ProgramFiles%` and `%ProgramFiles(x86)%`.
  - Converts retail licenses to Volume Licensing (VL) using official Microsoft KMS license certificates (`ospp.vbs`).
  - Includes a 5-server redundant failover pool with automatic retry logic:
    - `23.226.136.46`
    - `107.175.77.7`
    - `kms7.devomman.com`
    - `e8.us.to`
    - `kms7.MSGuides.com`

---

## 📋 Component Matrix

| Key | Component | Product / ID | Default State |
| :---: | :--- | :--- | :---: |
| `[1]` | **Microsoft Word** | `Word` | Included (YES) |
| `[2]` | **Microsoft Excel** | `Excel` | Included (YES) |
| `[3]` | **Microsoft PowerPoint** | `PowerPoint` | Included (YES) |
| `[4]` | **Microsoft Outlook** | `Outlook` | Included (YES) |
| `[5]` | **Microsoft OneNote** | `OneNote` | Included (YES) |
| `[6]` | **Microsoft Publisher** | `Publisher` | Included (YES) |
| `[7]` | **Microsoft Access** | `Access` | Included (YES) |
| `[8]` | **Microsoft Visio** | `VisioProRetail` | Included (YES) |
| `[9]` | **Microsoft Project** | `ProjectProRetail` | Included (YES) |
| `[P]` | **Proofing Tools** | `ProofingTools` / `LanguagePack` | Included (YES) |
| `[T]` | **Microsoft Teams** | `Teams` | Included (YES) |
| `[D]` | **Microsoft OneDrive** | `OneDrive` | Included (YES) |

---

## ⚙️ Configuration File Generation

The setup script dynamically generates a temporary `Office 365 Setup Config.xml` adhering to Microsoft ODT standards:

```xml
<Configuration>
  <Add OfficeClientEdition="64" Channel="Current" MigrateArch="TRUE">
    <Product ID="O365ProPlusRetail">
      <Language ID="MatchOS" Fallback="en-US" />
      <ExcludeApp ID="Bing" />
      <ExcludeApp ID="Groove" />
      <ExcludeApp ID="Lync" />
    </Product>
  </Add>
  <Updates Enabled="TRUE" />
  <Display Level="Full" AcceptEULA="TRUE" />
  <Property Name="ForceAppShutdown" Value="TRUE" />
  <AppSettings>
    <User Key="Software\Microsoft\Office\16.0\Word\Options" Name="defaultformat" Value="" Type="REG_SZ" App="word16" Id="L_SaveWordfilesas" />
    <User Key="Software\Microsoft\Office\16.0\Excel\Options" Name="defaultformat" Value="51" Type="REG_DWORD" App="excel16" Id="L_SaveExcelfilesas" />
    <User Key="Software\Microsoft\Office\16.0\PowerPoint\Options" Name="defaultformat" Value="27" Type="REG_DWORD" App="ppt16" Id="L_SavePowerPointfilesas" />
  </AppSettings>
</Configuration>
```

The configuration is automatically purged once the installation process finishes.

---

## 🛠️ Prerequisites & Requirements

- **Operating System**: Windows 10 or Windows 11 (32-bit, 64-bit, or ARM64).
- **Privileges**: Administrator rights required (scripts will auto-prompt for UAC elevation if not elevated).
- **Disk Space**:
  - Minimum **4.0 GB** free space for standard installation.
  - Approximately **10.0 GB** free space if downloading offline installation archives.
- **Network**: Active internet connection required for downloading packages or connecting to KMS activation hosts.

---

## ❓ Frequently Asked Questions (FAQ)

<details>
<summary><b>1. Why does the setup prompt for Administrator privileges?</b></summary>
Microsoft Office Deployment Tool (`setup.exe`) modifies system directories (`%ProgramFiles%`) and writes registry entries (`HKLM`) to register components and disable telemetry.
</details>

<details>
<summary><b>2. How do I install Office without an internet connection?</b></summary>
On an internet-connected PC, launch <code>Office 365 Setup.cmd</code>, toggle <code>[O]</code> to download offline files (~6.4 GB). Once downloaded, copy the entire directory to a USB flash drive or air-gapped machine and run the installer.
</details>

<details>
<summary><b>3. What should I do if KMS activation fails?</b></summary>
Ensure your firewall or antivirus is not blocking outbound traffic on port <b>1688</b>. The activator script automatically attempts 5 distinct public KMS servers across up to 15 retries before timing out.
</details>

---

## ⚖️ Disclaimer

This project is created for educational and testing purposes. Microsoft, Office 365, Word, Excel, PowerPoint, Outlook, and Windows are registered trademarks of Microsoft Corporation in the United States and other countries. Please support software developers by purchasing genuine licenses for commercial environments.

---

## 📄 License

This repository is licensed under the [MIT License](LICENSE).

