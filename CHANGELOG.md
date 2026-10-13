# Changelog

All notable changes to the VERA SmartChain sovereign node and CLI will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.0] - 2026-10-10

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
