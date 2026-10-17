# Changelog

All notable changes to the VERA SmartChain sovereign node and CLI will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.2.3-testnet] - 2026-10-17

### Added
- **Community Validator Onboarding Tooling**:
  - `sudo vera_cli keygen [--out <path>]`: Atomic key generation using direct `0600` permissions (`OpenOptions::mode(0o600)`), refusal to overwrite existing keys, and fail-hard ownership assignment to `vera:vera`.
  - `vera_cli syncwait`: Automated node synchronization waiter comparing local block height with remote RPC.
  - `sudo vera_cli apply-validator`: Generates cryptographically signed Ed25519 validator application blocks verified against timestamp window (7 days) and chain ID.
  - `sudo vera_cli approve-validator`: Automated governance onboarding CLI validating application blocks, inspecting `result.allowlist`, broadcasting on-chain `allow` governance transactions, and funding 33 VERA from treasury with automatic nonce resolution and retry.
  - `sudo vera_cli validator-status`: Dedicated validator consensus status reporting (`ACTIVE`, `JAILED`, `INACTIVE`, `UNREGISTERED`) with stake, missed blocks, and active peer counts.
- **Dedicated Validator Systemd Unit (`vera-validator.service`)**: Signed release asset configured with `Conflicts=vera-node.service` and strict sandboxing (`ProtectSystem=strict`, `NoNewPrivileges=true`).
- **Binary Attestation Tracking in Installer**: `install.sh` automatically records `expected_binary_sha256` in `/etc/vera/expected_binary_sha256` and installs both node and validator units.
- **GitHub Issue Template**: Added structured `validator-application.yml` issue form for community validator onboarding.

### Fixed
- **RPC Field Mapping in CLI**: `approve-validator` and `validator-status` now correctly inspect `result.allowlist` and standard RPC fields returned by `vera_getValidators`.

## [0.2.2-testnet] - 2026-10-16

### Added
- **Outbound Seed Connection Diagnostics & Logging**: `P2PService::maintain_seed_connections` now emits structured diagnostic logs with millisecond timing for seed handshake failures (TCP timeout, connection refused, Handshake send error, HandshakeAck timeout, EOF, read error, unexpected frame, or verification rejection).
- **Stable Failure Reason Categorization (`SeedFailureType`)**: Connection failures are classified by a stable category enum (`TcpTimeout`, `TcpRefused`, `HsSend`, `AckTimeout`, `AckEof`, `AckReadErr`, `AckUnexpected`, `AckRejected`, `Admission`), preventing repetitive log spam when measured socket timings fluctuate across retries.
- **Controlled Failure Recaps & Connecting Suppression**: Seed reconnection attempts log on initial failure (#1) and periodic recaps (#10, #20), while `Connecting to seed node` is emitted only once on the first attempt and suppressed during consecutive retries.
- **Inbound Reconnection Recovery**: Automatically removes failure trackers and emits a recovery line (`✅ [P2P Wire] Seed <addr> reconnected after N attempts (X s)`) when a seed connects via an inbound connection.
- **Peer Disconnection Duration & Telemetry**: Logs peer connection duration in seconds along with the last message type sent and received upon disconnect.

> **Note:** Zero consensus or network protocol changes. Fully backward-compatible with v0.2.1 nodes.

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
