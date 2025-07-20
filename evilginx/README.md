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

Install missing dependencies with:  

```bash
sudo apt install wget unzip -y   # Debian/Ubuntu
sudo pacman -S wget unzip        # Arch

🚀 Installation

    Download and make the script executable:

wget https://your-repo/install_evilginx.sh
chmod +x install_evilginx.sh

    Run the installer with your domain and public IP:

./install_evilginx.sh <domain> <public_ip>

▶️ Usage Example

Let’s say you want to set up Evilginx with:

    Domain: phishing.example.com

    Public IP: 203.0.113.45

Run:

./install_evilginx.sh phishing.example.com 203.0.113.45

This will:
✅ Create a directory called evilginx
✅ Download the latest Evilginx release
✅ Extract and make it executable
✅ Configure the domain phishing.example.com
✅ Configure the external IPv4 203.0.113.45

After installation, you can run Evilginx with:

cd evilginx
./evilginx -p ./

And check the current configuration:

./evilginx config

📂 What happens?

    A folder named evilginx will be created.

    The latest release of Evilginx will be downloaded and extracted there.

    Evilginx will briefly start to initialize configs.

    Your domain and external IPv4 will be set automatically.

⚠️ Notes

    This script is for educational and testing purposes only.

    Do not use Evilginx for illegal activities.

    Ensure you have proper authorization before using phishing frameworks.

❓ Troubleshooting

    If the download fails, check your network or GitHub availability.

    If Evilginx doesn’t run, ensure your Linux architecture matches the binary.

    To reinstall, remove the evilginx folder and run the script again.

🛠 Quick Workflow

# 1. Download script
wget https://your-repo/install_evilginx.sh
chmod +x install_evilginx.sh

# 2. Run installer with your domain and IP
./install_evilginx.sh attacker.com 198.51.100.20

# 3. Start Evilginx
cd evilginx
./evilginx -p ./

# 4. Verify configs
./evilginx config

📜 Disclaimer

This tool is intended for authorized penetration testing and security research only.
The author is not responsible for any misuse of this script.

