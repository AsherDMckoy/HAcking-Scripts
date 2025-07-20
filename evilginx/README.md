# Evilginx Installation Script

An automated installer script for Evilginx2 v3.3.0 that downloads, configures, and sets up the phishing framework with your domain and public IP.

## What This Script Does

This script automates the complete installation and initial configuration of Evilginx2:

1. **Downloads** the latest Evilginx2 release (v3.3.0) from GitHub
2. **Extracts** the binary to a local `evilginx/` directory
3. **Configures** your domain and public IP automatically
4. **Initializes** the framework ready for use

## Prerequisites

- Linux system (64-bit)
- `wget` installed
- `unzip` installed
- Root/sudo access (recommended for port 80/443 binding)
- A registered domain name
- Public IP address

### Installing Dependencies

**Ubuntu/Debian:**
```bash
sudo apt update
sudo apt install wget unzip
```

**CentOS/RHEL:**
```bash
sudo yum install wget unzip
```

## Installation

1. **Download the script:**
```bash
wget https://raw.githubusercontent.com/AsherDMckoy/HAcking-Scripts/refs/heads/main/evilginx/evilginx-setup.sh
chmod +x install_evilginx.sh
```

2. **Run the installer:**
```bash
./install_evilginx.sh <your-domain> <your-public-ip>
```

**Example:**
```bash
./install_evilginx.sh phishing.example.com 203.0.113.45
```

## Usage

After installation, the script will create an `evilginx/` directory in your current location.

**Start Evilginx:**
```bash
cd evilginx
sudo ./evilginx -p ./
```

**Why sudo?** Evilginx needs to bind to ports 80 and 443 for HTTP/HTTPS traffic.

## Directory Structure

After installation, you'll have:
```
evilginx/
├── evilginx                    # Main binary
├── evilginx-linux.zip         # Downloaded archive (can be deleted)
├── phishlets/                 # Phishing templates
├── redirectors/               # URL redirectors
└── [config files]            # Generated configuration
```

## Configuration

The script automatically configures:
- **Domain**: Your phishing domain
- **External IPv4**: Your public IP address

These settings are applied during installation, but you can modify them later within the Evilginx console:

```bash
evilginx : config domain new-domain.com
evilginx : config ipv4 external 192.0.2.100
```

## Common Issues & Troubleshooting

### "Evilginx seems to already be installed"
The script detected an existing installation. Remove the `evilginx/` directory first:
```bash
rm -rf evilginx/
```

### "Permission denied" when starting Evilginx
Evilginx needs root privileges to bind to ports 80/443:
```bash
sudo ./evilginx -p ./
```

### "Download failed"
Check your internet connection and verify the GitHub release URL is accessible:
```bash
curl -I https://github.com/kgretzky/evilginx2/releases/download/v3.3.0/evilginx-v3.3.0-linux-64bit.zip
```

### DNS Configuration
Ensure your domain's DNS points to your server:
```bash
# Check DNS resolution
nslookup your-domain.com

# Should return your public IP
```

## Security Considerations

**⚠️ Legal Notice:** This tool is for authorized security testing only. Ensure you have explicit permission before testing against any systems you don't own.

**Best Practices:**
- Use only in controlled environments
- Obtain proper authorization before testing
- Keep logs for legitimate security assessments
- Follow your organization's security policies

## Advanced Configuration

### Custom Installation Directory
To install in a different location, run the script from that directory:
```bash
mkdir /opt/phishing-tools
cd /opt/phishing-tools
/path/to/install_evilginx.sh domain.com 1.2.3.4
```

### Firewall Configuration
Ensure ports 80 and 443 are open:
```bash
# UFW (Ubuntu)
sudo ufw allow 80
sudo ufw allow 443

# iptables
sudo iptables -A INPUT -p tcp --dport 80 -j ACCEPT
sudo iptables -A INPUT -p tcp --dport 443 -j ACCEPT
```

### SSL Certificate Setup
Evilginx handles SSL certificates automatically, but ensure:
- Your domain resolves to your server
- Ports 80/443 are accessible from the internet
- No other web servers are running on these ports

## Uninstallation

To completely remove Evilginx:
```bash
# Stop any running instances
sudo pkill evilginx

# Remove installation directory
rm -rf evilginx/

# Remove the installer script (optional)
rm install_evilginx.sh
```

## Support

For issues with:
- **This installer script**: Create an issue in this repository
- **Evilginx itself**: Visit the [official Evilginx2 repository](https://github.com/kgretzky/evilginx2)
- **Phishlet creation**: Check the [Evilginx documentation](https://help.evilginx.com/)

## Version Information

- **Script Version**: 2.0
- **Evilginx Version**: 3.3.0
- **Supported Platforms**: Linux 64-bit

## License

This installation script is provided as-is for educational and authorized testing purposes only. Evilginx2 itself is subject to its own license terms.
