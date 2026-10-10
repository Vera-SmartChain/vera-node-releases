# 🌐 VERA Network - Official Node Releases

Welcome to the official release repository for the **VERA Network**!

VERA is a high-performance L1 blockchain, built from scratch in Rust, designed for enterprise use, SaaS infrastructure, and the deterministic execution of Smart Contracts through our native, ultra-secure integration with the EVM (100% Opcode Equivalence).

This repository provides pre-compiled binaries, Docker images, and official configuration files so the community can connect, validate, and build on the VERA network.

> 🔒 **Architecture Note:** The source code for VERA's core consensus engine and the CSMT tree is proprietary closed-source IP (*Open-Core Model*). However, this repository contains everything you need to operate a full node, become a validator, and interact freely with the network.

---

## 🚀 How to Participate in the Network

There are two primary ways to run a Node on the VERA Network:

### 1. Observer Node / RPC (Full Node)
Anyone can run a Full Node. It downloads a copy of the entire blockchain, validates the rules locally, and exposes an RPC API.
* **Ideal use case:** DApp developers, Exchanges, SaaS services that need to read blockchain data without relying on third-party public nodes.
* **Requirements:** Free and open (no permission or stake required).

### 2. Validator / Mini-Validator
Validator nodes actively participate in network consensus, propose new blocks, and earn rewards based on network fees (Gas).
* **Ideal use case:** Infrastructure providers and strategic partners.
* **Requirements:** Because VERA has a strict focus on corporate stability and *Fail-Hard security*, new validators must pass a *Stake* process (locking `$VERA` tokens) and have their public key approved in the validator contract. [Read more in the Validators section](#-how-to-become-a-validator).

---

## ⚙️ Hardware Requirements (Recommended)
- **CPU:** 4 Cores (x86_64 or ARM64 Architecture)
- **RAM:** 8 GB+
- **Storage:** 100 GB+ NVMe SSD
- **OS:** Ubuntu 22.04 LTS / 24.04 LTS

---

## 🛠️ Quick Setup (Testnet)

The fastest way to spin up a node is using Docker.

### Step 1: Clone the configurations
```bash
git clone https://github.com/Vera-Network/vera-node-releases.git
cd vera-node-releases/testnet
```

### Step 2: Start the Node
Using the official `docker-compose` provided in this repository:
```bash
docker-compose up -d
```

### Step 3: Check the logs
To confirm your node has connected to the VERA peers (Gossip network) and started syncing the Merkle tree:
```bash
docker logs -f vera-node
```

> **RPC Access:** By default, the node exposes HTTP port `8545`. You can connect your MetaMask or Hardhat directly to `http://localhost:8545`.

---

## 📥 Manual Downloads (Bare-Metal)

If you prefer to run the binary directly on your server (without Docker), download the latest releases from the [Releases](https://github.com/Vera-Network/vera-node-releases/releases) tab.

**Example on Linux:**
```bash
wget https://github.com/Vera-Network/vera-node-releases/releases/download/v1.0.0/vera_node_linux_amd64
chmod +x vera_node_linux_amd64
./vera_node_linux_amd64 --network testnet
```

---

## ⚖️ How to become a Validator

For the network to accept your block signatures:
1. Generate a key pair using our integrated CLI: `./vera_node keys generate`.
2. The node will output a Public Key (Your identity on the network). Keep the Private Key in a secure location, as it will sign the blocks.
3. Submit your Public Key through the [VERA Validator Portal](#) (Link coming soon) to perform the required `$VERA` stake.
4. Once approved, restart your node with the `--validator` flag.

---

## 📚 Useful Links
- **Block Explorer:** [https://explorer.verachain.cloud/](https://explorer.verachain.cloud/)
- **Smart Contract Documentation:** Since VERA is 100% EVM Equivalent, all standard Solidity tutorials (Hardhat, Foundry, Truffle) work out of the box on the VERA network.
- **Public Testnet RPC:** `https://testnet-rpc.verachain.cloud`
- **Chain ID:** `777` (Example)

---

## 🛡️ Security and Bug Reporting
The Rust core of VERA adheres to the **Fail-Hard** principle: any suspicious code execution causes a protective halt, rather than failing silently into a corrupted state.
If you encounter any unexpected behavior with the binary, please open an *Issue* in this repository describing how to reproduce the problem.

---
*VERA Network - Decentralized, Deterministic, and Built for Business.*
