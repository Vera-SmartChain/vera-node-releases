# Security Policy

VERA Network takes the security of our blockchain, network, and node operators seriously. This document outlines our vulnerability disclosure policy, security scope, and safe harbor guidelines.

---

## 🔒 Reporting a Vulnerability

> **CRITICAL:** **NEVER report security vulnerabilities or sensitive exploits via public GitHub Issues or public discussion channels.**

If you discover a security vulnerability, bug, or potential exploit affecting the VERA Network, please report it directly and privately to our dedicated security team:

* **Email:** [security@verachain.cloud](mailto:security@verachain.cloud)
* **PGP Key:** Available upon request or via our official security site.

Please include the following information in your advisory:
1. **Description:** A detailed explanation of the vulnerability and its potential impact.
2. **Steps to Reproduce:** Exact steps, scripts, transaction payloads, or proof-of-concept (PoC) code to reproduce the issue in an isolated environment.
3. **Environment:** Node version, commit hash, operating system, network type (Testnet or Mainnet), and hardware configuration.
4. **Suggested Mitigation (Optional):** Any recommended code fix or mitigation strategy.

---

## ⏱️ Response Timelines & SLAs

Our security response team follows a strict triage and patching workflow:

| Stage | Target Timeline |
|---|---|
| Initial Acknowledgement | Within **24 to 48 hours** |
| Severity Triage & Assessment | Within **5 business days** |
| Patch Development & Testing | Dependent on severity; critical issues prioritized for immediate emergency hotfix |
| Coordinated Public Disclosure | After patches have been deployed to active validators and public binaries are published |

---

## 🎯 Scope

### In-Scope
* **Node Core (`vera_node`):** Consensus engine, validator voting, state transitions, CSMT Merkle tree integrity.
* **EVM Execution Environment:** Opcode equivalence, deterministic smart contract execution, state isolation.
* **P2P Wire Protocol:** DoS resilience, frame parsing, peer manager, handshake security, gossip propagation.
* **JSON-RPC Interface:** Rate limiting, authentication, parser memory bounds, transaction validation.

### Out-of-Scope
* Social engineering or phishing attacks against VERA contributors or node operators.
* Physical security of data centers or third-party cloud infrastructure.
* Attacks requiring physical access to a compromised validator server.
* Vulnerabilities in third-party Solidity contracts deployed by independent developers that do not affect the L1 execution layer.

---

## 🛡️ Safe Harbor Policy

We strongly believe in supporting security researchers who act in good faith. If you conduct your research in accordance with this policy:
* We will **not** pursue legal action against you.
* We will work collaboratively with you to understand and resolve the issue promptly.
* We request that you give us reasonable time to deploy patches before disclosing any technical details publicly (*Coordinated Vulnerability Disclosure*).

---

## 🐛 Public Issues

Public GitHub issues on this repository are restricted to:
* General bug reports with no security implications (e.g., CLI formatting, compilation issues on specific distributions).
* Documentation clarifications and enhancement suggestions.
* Feature requests.

Any public issue containing suspected security vulnerabilities will be closed immediately and converted to a confidential report.
