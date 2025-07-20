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

# ==== ARGUMENT CHECK ====
if [ $# -ne 2 ]; then
    echo "Usage: $0 <domain> <public_ip>"
    exit 1
fi

DOMAIN=$1
PUBLIC_IP=$2

# ==== CHECK IF ALREADY INSTALLED ====
if command -v ./$INSTALL_DIR/$BINARY_NAME &> /dev/null; then
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

# ==== RUN EVILGINX ONCE TO INIT CONFIG ====
echo "[*] Starting Evilginx to initialize..."
./"$BINARY_NAME" -p ./ &

EVILGINX_PID=$!
sleep 5

if ! kill -0 $EVILGINX_PID 2>/dev/null; then
    error_exit "Evilginx did not start properly."
fi

# ==== CONFIGURE DOMAIN AND IP ====
echo "[*] Configuring Evilginx domain and IP..."
./"$BINARY_NAME" config domain "$DOMAIN" || error_exit "Failed to set domain."
./"$BINARY_NAME" config ipv4 external "$PUBLIC_IP" || error_exit "Failed to set public IP."

# ==== STOP EVILGINX ====
kill $EVILGINX_PID

echo "[+] Evilginx installed and configured!"
echo "    Domain: $DOMAIN"
echo "    Public IP: $PUBLIC_IP"
echo
echo "Run it with: cd $INSTALL_DIR && ./$BINARY_NAME -p ./"

exit 0

