#!/bin/bash
# Usage: ./install_evilginx.sh <domain> <public_ip>

# ==== CONFIG ====
RELEASE_URL="https://github.com/kgretzky/evilginx2/releases/download/v3.3.0/evilginx-v3.3.0-linux-64bit.zip"
INSTALL_DIR="evilginx"
RELEASE_FILE="evilginx-linux.zip"
BINARY_NAME="evilginx"
CONFIG_DIR=".evilginx"

# ==== FUNCTIONS ====
error_exit() {
    echo "[!] $1"
    exit 1
}

cleanup() {
    if [[ -n $EVILGINX_PID ]] && kill -0 $EVILGINX_PID 2>/dev/null; then
        echo "[*] Stopping Evilginx..."
        kill $EVILGINX_PID
        wait $EVILGINX_PID 2>/dev/null
    fi
}

# Set trap for cleanup
trap cleanup EXIT

# ==== ARGUMENT CHECK ====
if [ $# -ne 2 ]; then
    echo "Usage: $0 <domain> <public_ip>"
    exit 1
fi

DOMAIN=$1
PUBLIC_IP=$2

# ==== CHANGE TO SCRIPT DIRECTORY ====
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "[*] Script location: $SCRIPT_DIR"
cd "$SCRIPT_DIR" || error_exit "Failed to change to script directory."

# ==== CHECK IF ALREADY INSTALLED ====
if [[ -f "$INSTALL_DIR/$BINARY_NAME" ]]; then
    echo "[!] Evilginx seems to already be installed. Remove $INSTALL_DIR first if you want a fresh install."
    exit 1
fi

# ==== CREATE DIRECTORY ====
echo "[*] Creating install directory: $INSTALL_DIR"
mkdir -p "$INSTALL_DIR" || error_exit "Failed to create directory."
cd "$INSTALL_DIR" || error_exit "Failed to enter install directory."

# ==== DOWNLOAD RELEASE ====
echo "[*] Downloading Evilginx release..."
wget -q --show-progress "$RELEASE_URL" -O "$RELEASE_FILE" || error_exit "Download failed."

# ==== VERIFY DOWNLOAD ====
if [ ! -f "$RELEASE_FILE" ]; then
    error_exit "Release file not found after download."
fi

# ==== UNZIP ====
echo "[*] Extracting release..."
unzip -o "$RELEASE_FILE" || error_exit "Failed to unzip release."

# ==== MAKE EXECUTABLE ====
chmod +x "$BINARY_NAME" || error_exit "Failed to make binary executable."

# ==== VERIFY BINARY WORKS ====
echo "[*] Testing Evilginx binary..."
if ! ./"$BINARY_NAME" --help >/dev/null 2>&1; then
    error_exit "Evilginx binary is not working properly."
fi

# ==== CREATE CONFIG FILE ====
echo "[*] Creating Evilginx configuration file..."

# Create the config directory if it doesn't exist
mkdir -p ~/$CONFIG_DIR || error_exit "Failed to create config directory" 

# Create the config.file 
touch ~/$CONFIG_DIR/config.json || error_exit "Failed to create config.json file."

# Create config.yaml with the provided domain and IP
cat > ~/$CONFIG_DIR/config.json<< EOF
{
    "general : {
	"domain": "$DOMAIN",
    	"bind_ipv4": "0.0.0.0",
	"dns_port": 5344,
    	"external_ipv4": "$PUBLIC_IP",
    	"https_port": 443,
    	"blacklist_mode": "unauth",
     }
}
EOF

echo "[*] Configuration file created: ~/$CONFIG_DIR/config.yaml"

echo "[+] Evilginx installed and configured!"
echo "    Domain: $DOMAIN"
echo "    Public IP: $PUBLIC_IP"
echo "    Config: $CONFIG_DIR/config.json"
echo
echo "To resolve DNS port conflict (common issue):"
echo "  sudo systemctl stop systemd-resolved"
echo
echo "Run it with: cd $INSTALL_DIR && sudo ./$BINARY_NAME"
exit 0
