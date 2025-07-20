#!/bin/bash
# Usage: ./install_evilginx.sh <domain> <public_ip>

# ==== CONFIG ====
RELEASE_URL="https://github.com/kgretzky/evilginx2/releases/download/v3.3.0/evilginx-v3.3.0-linux-64bit.zip"
INSTALL_DIR="evilginx"
RELEASE_FILE="evilginx-linux.zip"
BINARY_NAME="evilginx"

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

# ==== CONFIGURE USING COMMAND FILE METHOD ====
echo "[*] Preparing configuration commands..."

# Create a temporary command file
cat > config_commands.txt << EOF
config domain $DOMAIN
config ipv4 external $PUBLIC_IP
exit
EOF

echo "[*] Running Evilginx with configuration..."
./"$BINARY_NAME" -p ./ < config_commands.txt &
EVILGINX_PID=$!

# Wait a bit for commands to process
sleep 10

# Clean up command file
rm -f config_commands.txt

echo "[+] Evilginx installed and configured!"
echo "    Domain: $DOMAIN"
echo "    Public IP: $PUBLIC_IP"
echo
echo "Run it with: cd $INSTALL_DIR && ./$BINARY_NAME -p ./"
exit 0
