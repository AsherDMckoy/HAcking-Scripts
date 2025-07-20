# Evilginx Installer Script

This is a simple Bash script that automates the installation and basic configuration of **[Evilginx2](https://github.com/kgretzky/evilginx2)** from its GitHub releases.  

It downloads the latest release, extracts it, makes it executable, and sets up your **domain** and **public IP address** automatically.  

---

## ✅ Features

- Creates a clean install directory for Evilginx  
- Downloads the **latest release** from GitHub  
- Extracts the binary and makes it executable  
- Initializes Evilginx and configures:
  - Your custom **domain**  
  - Your **external public IPv4**  
- Includes basic error handling  
- Prevents accidental reinstallation if already installed  

---

## 🔧 Requirements

- Linux (Ubuntu, Debian, Arch, etc.)
- `wget`  
- `unzip`  
- `bash`  

You can install missing dependencies with:  

```bash
sudo apt install wget unzip -y   # Debian/Ubuntu
sudo pacman -S wget unzip        # Arch

