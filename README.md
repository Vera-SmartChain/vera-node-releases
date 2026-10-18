# 🌐 VERA SmartChain — Official Node Releases

Official release repository for the **VERA SmartChain** (Testnet).

VERA SmartChain is an enterprise-grade Layer-1 blockchain built from the ground up in Rust, featuring a high-performance BFT-PoS consensus engine, state commitment via Compact Sparse Merkle Trees (CSMT), and deterministic EVM smart contract execution powered by `revm`.

This repository provides pre-compiled binaries, configuration files, cryptographic signatures, and deployment units for running observer nodes, RPC endpoints, and validator nodes on the VERA SmartChain Testnet.

---

## 📋 Verified Network Parameters (Testnet)

All values below have been verified on the active, live network:

| Parameter | Specification | Notes |
| :--- | :--- | :--- |
| **Network Name** | VERA SmartChain Testnet | Display name for wallets and explorers |
| **EVM Chain ID** | `83721` (`0x14709`) | EIP-155 replay protection enforced |
| **Internal Chain ID** | `vera-testnet-1` | Consensus level identifier |
| **Currency Symbol** | `VERA` | 18 decimals |
| **Public RPC Endpoint** | `https://testnet-rpc.verachain.cloud` | Rate-limited (25 req/s burst, 600 req/min) |
| **Block Explorer** | `https://testnet-explorer.verachain.cloud` | Real-time blocks, transactions, and contracts |
| **Official Faucet** | `https://testnet-faucet.verachain.cloud` (or `https://verachain.cloud/staking`) | Rate-limited on-chain faucet (1 VERA / 24h per IP/wallet) |
| **P2P Seed Peer** | `2.25.216.206:26656` | Default bootstrap node |
| **Block Production** | Event-driven BFT consensus | Blocks proposed and finalized upon pending transactions |
| **Minimum Validator Stake** | `32 VERA` (`32000000000000000000` wei) | Enforced on-chain |

> ⚠️ **Testnet Notice:** The VERA SmartChain Testnet is an active test environment. Token balances have zero monetary value. Breaking protocol upgrades may occasionally require scheduled, coordinated testnet resets announced in advance.

---

## ⚙️ System Requirements

### Minimum (Measured in Live Production)
- **CPU:** 1 vCPU (x86_64 architecture)
- **RAM:** 2 GB
- **Storage:** 20 GB SSD
- **OS:** Linux (Ubuntu 22.04 LTS or 24.04 LTS), `glibc` ≥ 2.34

### Recommended (Full Production RPC / Validator)
- **CPU:** 2–4 Cores (x86_64)
- **RAM:** 4–8 GB
- **Storage:** 100 GB NVMe SSD
- **Network:** 100 Mbps uplink, static IPv4

---

## 🔐 Release Verification & Authenticity

Every official release artifact is cryptographically signed offline by the VERA Core team using Ed25519 GPG release keys.

### 1. Download Release Artifacts
Download `install.sh`, `vera_node`, `vera_cli`, `testnet-genesis.json`, `SHA256SUMS`, `SHA256SUMS.sig`, and `vera-release.pub`.

### 2. Verify SHA-256 Checksums
```bash
sha256sum -c SHA256SUMS
```
*(All release components must return `OK`)*

### 3. Import and Verify GPG Release Signature
```bash
# Import the official public release key
gpg --import vera-release.pub

# Verify cryptographic signature of the checksum manifest
gpg --verify SHA256SUMS.sig SHA256SUMS
```

**Mandatory Verification Step:**
Confirm that the output matches the official primary key fingerprint:
```text
Primary key fingerprint: 37F3 9BD8 9ADE E9EE E554  9C38 8974 19EF F806 BE51
```
*(Always compare this fingerprint against official publications. If the fingerprint diverges, do not execute the binary)*

---

## 🚀 Quick Start with `vera-join` (Recommended)

The automated `vera-join` management script streamlines full node and validator operations, including cryptographic GPG verification, candidate block emission, staking activation, and safe automated upgrades.

> 🤖 **For AI Agents & Automation:** See canonical machine-readable instructions in [`llms.txt`](https://docs.verachain.cloud/llms.txt).

### 1. Download & Verify Release Bundle (v0.2.4.1-testnet)

```bash
# Create a clean directory
mkdir -p ~/vera-v0.2.4.1-testnet && cd ~/vera-v0.2.4.1-testnet

# Download all 11 canonical release artifacts
RELEASE_URL="https://github.com/Vera-SmartChain/vera-node-releases/releases/download/v0.2.4.1-testnet"
for f in install.sh RELEASE.json SHA256SUMS SHA256SUMS.sig testnet-genesis.json vera-join.sh vera-node.service vera-release.pub vera-validator.service vera_cli vera_node; do
    curl -sSfLO "${RELEASE_URL}/${f}"
done

# Cryptographic GPG & Checksum Verification
gpg --import vera-release.pub
gpg --verify SHA256SUMS.sig SHA256SUMS
sha256sum -c SHA256SUMS
```

### 2. Node Bootstrap & Validator Candidacy

Bootstrap the node, setup system services, and print the signed candidate block:
```bash
sudo bash vera-join.sh --operator "@your_github_or_handle"
```
Submit the generated `-----BEGIN VERA VALIDATOR APPLICATION-----` block via the [Validator Application Issue Template](https://github.com/Vera-SmartChain/vera-node-releases/issues/new?template=validator-application.yml).

### 3. Activation & Staking (Post-Governance Approval)

Once approved on the on-chain governance allowlist and funded with 32 VERA stake allocation, activate validator mode:
```bash
sudo vera-join --activate
```
*Prerequisites: Validator key in `/etc/vera/validator_key.hex`, on-chain allowlist authorization (`allow:`), and at least 32 VERA balance.*

### 4. Seamless Upgrades & Maintenance

```bash
# Manual upgrade to latest official release with automatic rollback if health checks fail
sudo vera-join --upgrade

# Enable daily automated upgrade check (opt-in systemd timer)
sudo vera-join --enable-auto-upgrade

# Disable automated upgrade timer
sudo vera-join --disable-auto-upgrade

# View full help and operational flags
vera-join --help
```

---

## 🚀 Running a Full Node (Observer / RPC)

Full nodes sync the entire blockchain state, validate transactions and blocks against consensus rules, and expose standard Ethereum-compatible JSON-RPC endpoints for local dApps and wallets.

### Manual Setup (Bare-Metal)

1. Make binaries executable:
   ```bash
   chmod +x vera_node vera_cli
   ```

2. Create a dedicated data directory:
   ```bash
   mkdir -p ./data
   ```

3. Launch the node connected to the official seed peer:
   ```bash
   ./vera_node \
     --genesis genesis.json \
     --data-dir ./data \
     --rpc-port 8545 \
     --p2p-port 26656 \
     --seed-peers 2.25.216.206:26656
   ```

4. Verify sync progress:
   ```bash
   curl -s -X POST http://127.0.0.1:8545 \
     -H "Content-Type: application/json" \
     -d '{"jsonrpc":"2.0","id":1,"method":"eth_blockNumber","params":[]}'
   ```

---

## 🛡️ Production Deployment with Systemd

For 24/7 reliability, run `vera_node` under a dedicated, non-root system user with strict Linux sandboxing.

1. Create a dedicated system user and working directory:
   ```bash
   sudo useradd -r -s /usr/sbin/nologin -d /var/lib/vera vera
   sudo mkdir -p /var/lib/vera/data /etc/vera
   sudo cp genesis.json /etc/vera/testnet-genesis.json
   sudo cp vera_node /usr/local/bin/vera_node
   sudo chmod 755 /usr/local/bin/vera_node
   sudo chown -R vera:vera /var/lib/vera
   sudo chown root:vera /etc/vera/testnet-genesis.json
   sudo chmod 0640 /etc/vera/testnet-genesis.json
   ```

2. Install the hardened service unit [`vera-node.service`](vera-node.service):
   ```bash
   sudo cp vera-node.service /etc/systemd/system/
   sudo systemctl daemon-reload
   sudo systemctl enable --now vera-node
   ```

3. Monitor logs:
   ```bash
   journalctl -u vera-node -f
   ```

---

## ⚖️ How to Become a Validator

VERA SmartChain uses a permissioned validator set on testnet to ensure enterprise-grade stability and prevent Sybil degradation of BFT consensus.

1. **Generate your cryptographic validator key pair:**
   ```bash
   ./vera_cli keygen
   ```
   Save the private key to `/etc/vera/validator_key.hex`:
   ```bash
   sudo mkdir -p /etc/vera
   echo -n "<YOUR_PRIVATE_KEY_HEX>" | sudo tee /etc/vera/validator_key.hex >/dev/null
   sudo chown vera:vera /etc/vera/validator_key.hex
   sudo chmod 0600 /etc/vera/validator_key.hex
   ```

2. **Request Allowlist Authorization & Testnet Staking Allocation:**
   Because public faucets provide 1 VERA/day per address, the Governance team transfers the required 32 VERA onboarding allocation directly to authorized testnet validators.
   - Contact `contact@verachain.cloud` with your validator **Address** and **Public Key**.
   - The governance executes an on-chain allowlist transaction (`allow:<YOUR_ADDRESS>`) and funds your validator address with 32 VERA.

3. **Deposit Validator Stake (Minimum 32 VERA):**
   Once funded and authorized on-chain, bond your stake directly using `vera_cli`:
   ```bash
   # Syntax: ./vera_cli stake <private_key_hex> <amount_wei>
   ./vera_cli stake <YOUR_PRIVATE_KEY_HEX> 32000000000000000000
   ```

4. **Start Node in Validator Mode:**
   Add `--validator --key-file /etc/vera/validator_key.hex` to your startup command or systemd unit file.

5. **Unstaking:**
   To unstake and exit the validator set:
   ```bash
   # Syntax: ./vera_cli unstake <private_key_hex> <amount_wei>
   ./vera_cli unstake <YOUR_PRIVATE_KEY_HEX> 32000000000000000000
   ```
   Unbonding completes automatically after 5 blocks on Testnet.

> ⚠️ **Availability Commitment:** BFT consensus requires at least 2/3 + 1 of active stake online to commit blocks. Offline validators disrupt network liveness and may be removed from the active set.

---

## 💻 Smart Contract Development

VERA SmartChain is fully compatible with the Ethereum Virtual Machine (EVM) via `revm`. You can use your favorite developer tools:

- **Hardhat:** Set `url: "https://testnet-rpc.verachain.cloud"` and `chainId: 83721`.
- **Foundry:** Set `eth_rpc_url = "https://testnet-rpc.verachain.cloud"` in `foundry.toml`.
- **MetaMask:** Add custom network using Chain ID `83721` (`0x14709`).
- **Events & Logs:** Full support for `eth_getLogs` with Bloom filter indexing (up to 5,000 blocks per query).

Refer to the [vera-contracts-examples](https://github.com/Vera-SmartChain/vera-contracts-examples) repository for complete starter kits with automated deployment scripts and tests.

---

## 🔒 Security & Vulnerability Disclosure

Security is fundamental to the VERA architecture. All code follows the **Fail-Hard** principle: invalid cryptographic state triggers an explicit error rather than undefined behavior.

> 🚨 **Responsible Disclosure:**
> Please **DO NOT** report security vulnerabilities via public GitHub issues.
> For responsible disclosure, contact: **`security@verachain.cloud`**
> See [SECURITY.md](SECURITY.md) for full policy, response SLAs, and scope.

---

## 📄 License

This repository and all associated artifacts are licensed under the [Apache License, Version 2.0](LICENSE).
See the [NOTICE](NOTICE) file for additional attribution notices.

---

*VERA SmartChain — Deterministic, Verifiable, Enterprise-Grade.*  
*Website: [verachain.cloud](https://verachain.cloud) • Inquiries: [contact@verachain.cloud](mailto:contact@verachain.cloud)*
