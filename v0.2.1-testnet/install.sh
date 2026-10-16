#!/usr/bin/env bash
set -euo pipefail

EXPECTED_FINGERPRINT="37F39BD89ADEE9EEE5549C38897419EFF806BE51"

echo "============================================================"
echo "  VERA SmartChain Testnet — Node Installer (Bare-Metal)     "
echo "============================================================"

# 1. Architecture Check
ARCH=$(uname -m)
if [ "$ARCH" != "x86_64" ]; then
    echo "❌ Error: Only Linux x86_64 is officially supported at this stage. Detected: $ARCH"
    exit 1
fi

# 2. Dependency Check
for cmd in gpg sha256sum curl; do
    if ! command -v "$cmd" >/dev/null 2>&1; then
        echo "❌ Error: Required tool '$cmd' is not installed."
        exit 1
    fi
done

# 3. Verify Release Authenticity (Fail-Hard)
echo "🔍 Verifying cryptographic release signatures..."

for required_file in "vera-release.pub" "SHA256SUMS.sig" "SHA256SUMS" "vera_node" "vera_cli" "testnet-genesis.json"; do
    if [ ! -f "$required_file" ]; then
        echo "❌ Error: Missing mandatory release file '$required_file'. Aborting installation."
        exit 1
    fi
done

# Create temporary isolated GNUPGHOME
GNUPG_TMP=$(mktemp -d)
trap 'rm -rf "$GNUPG_TMP"' EXIT
export GNUPGHOME="$GNUPG_TMP"

# Import public key
gpg --batch --quiet --import vera-release.pub

# Verify signature and check VALIDSIG strictly
SIG_STATUS=$(gpg --batch --status-fd 1 --verify SHA256SUMS.sig SHA256SUMS 2>&1 || true)

if ! echo "$SIG_STATUS" | grep -q "^\[GNUPG:\] VALIDSIG $EXPECTED_FINGERPRINT "; then
    echo "❌ Error: GPG signature verification failed or fingerprint mismatch!"
    echo "Expected VALIDSIG: $EXPECTED_FINGERPRINT"
    exit 1
fi

# Check SHA-256 hashes
if ! sha256sum -c SHA256SUMS; then
    echo "❌ Error: SHA-256 checksum mismatch! Release files may be corrupted or tampered."
    exit 1
fi

echo "✅ Cryptographic verification passed: Valid signature from $EXPECTED_FINGERPRINT"

# 4. Create Dedicated System User
if ! id -u vera >/dev/null 2>&1; then
    echo "👤 Creating dedicated non-root user 'vera'..."
    sudo useradd -r -s /usr/sbin/nologin -d /var/lib/vera vera
fi

# 5. Directory Setup
echo "📁 Setting up /var/lib/vera and /etc/vera..."
sudo mkdir -p /var/lib/vera/data /etc/vera

sudo cp testnet-genesis.json /etc/vera/testnet-genesis.json
sudo chown root:vera /etc/vera/testnet-genesis.json
sudo chmod 0640 /etc/vera/testnet-genesis.json

# 6. Install Binaries
sudo cp vera_node /usr/local/bin/vera_node
sudo chmod 755 /usr/local/bin/vera_node

sudo cp vera_cli /usr/local/bin/vera_cli
sudo chmod 755 /usr/local/bin/vera_cli

sudo chown -R vera:vera /var/lib/vera

# 7. Systemd Service Setup
if [ -f "vera-node.service" ]; then
    echo "⚙️ Installing systemd service unit..."
    sudo cp vera-node.service /etc/systemd/system/
    sudo systemctl daemon-reload
    echo "Service installed! To enable and start:"
    echo "  sudo systemctl enable --now vera-node"
fi

echo "============================================================"
echo "🎉 VERA SmartChain node installation completed successfully!"
echo "============================================================"
