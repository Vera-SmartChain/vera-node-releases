# Changelog

All notable changes to the VERA SmartChain sovereign node and CLI will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.1-testnet] - 2026-10-15

### Fixed
- **P2P Socket Leak Resolution**: Cooperative cancellation via `watch` channel, explicit TCP shutdown on disconnect, deduplication by public key with monotonic `conn_id`, and strict peer closure in <= 15s for stalled peers (1 connection per peer).
- **HTTPS RPC Support for `vera_cli`**: Added `rustls-tls` to `reqwest` so `vera_cli` connects natively over HTTPS (`https://testnet-rpc.verachain.cloud`).

### Added
- **Automatic Nonce Resolution in `vera_cli`**: When `[nonce]` argument is omitted in signing commands (`transfer`, `stake`, `unstake`, `unjail`, `allow`, `disallow`, `set_governance`), `vera_cli` automatically queries `vera_getAccount` on `VERA_RPC_URL`.
- **Hardened Systemd Unit Asset**: Added `vera-node.service` with strict sandboxing (systemd security score `2.1 OK`) as a signed release asset.
- **Reproducible Release Build**: Documented official build command `cargo build --release -p vera-blockchain`.

> **Note:** No protocol, consensus, or genesis changes. Fully compatible with testnet genesis.

## [0.2.0-testnet] - 2026-10-14

### Changed
- **BLAKE3 Cryptographic Unification**: Transitioned block hashing, state roots, and transaction proofs to BLAKE3.
- **Testnet Genesis Hash**: Standardized canonical testnet genesis `988a0dc3...`.

## [0.1.0-testnet] - 2026-10-10

### Added
- **EVM Compatibility (revm v43)**: Integrated revm execution engine against the CSMT (Compact Sparse Merkle Tree) state.
- **RPC Gateway**:
  - `eth_chainId`, `net_version`, `web3_clientVersion`, `eth_blockNumber`.
  - `eth_getBalance`, `eth_getTransactionCount`, `eth_getCode`, `eth_getStorageAt`.
  - `eth_call`, `eth_estimateGas`, `eth_gasPrice`, `eth_feeHistory`.
  - `eth_sendRawTransaction`: Nonce and balance pre-validation, mempool admission, P2P gossip, deterministic on-chain block execution.
  - `eth_getTransactionByHash`, `eth_getTransactionReceipt` with `contractAddress`, `status`, `logsBloom`.
  - `eth_getLogs`: Topic and address filtering with 5,000 block maximum query limit.
- **BFT-PoS Consensus**: 2/3 stake threshold with round-robin proposer selection and deterministic block proposals.
- **Fail-Hard Binary Attestation**: Automated binary sha256 integrity verification via `vera_getNodeAttestation`.
- **Faucet Rate Limiting**: IP-based (`X-Forwarded-For`) and wallet-based cooldown persisted across node restarts to disk.
- **CLI Utilities (`vera_cli`)**: Full validator lifecycle management, genesis building, and testnet interactions.
- **Security Hardening**: Anti-Slowloris 10s socket timeouts, 1MB bounded payload limits, memory-bounded mempools with RBF eviction.
