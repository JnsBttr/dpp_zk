# dpp_zk

A project to implement Zero-Knowledge Proofs (zkProofs) within Digital Product Passports (DPP).

## 🚀 Project Overview

This repository provides a structured approach for compiling, proving and verifying zkProof circuits using [Circom](https://docs.circom.io/) and [snarkjs](https://github.com/iden3/snarkjs).  
The project is designed for simplicity and scalability, making it easy to test and deploy zk circuits.

---

## 📦 Folder Structure

```
dpp_zk/
├── circuits/          # .circom files
├── build/             # Auto-generated build files (.r1cs, .zkey, Verifier.sol)
├── proofs/            # Auto-generated proofs and public signals
├── inputs/            # Input json files for circuits
├── scripts/           # Helper scripts for each step
└── verifier/          # (Optional) Solidity verifier templates
```

---

## 📖 Usage

### 1️⃣ Install environment (see `scripts/install_dpp_setup.sh`)

```bash
./install_dpp_setup.sh
```

### 2️⃣ Write your Circuit

Create your `.circom` file in the `circuits/` folder.

Example:

```
circuits/
└── test.circom
```

### 3️⃣ Build Proof (compile, generate zkey, create verifier)

```bash
./build_proof.sh test
```

> This will create artifacts in `build/test/` (r1cs, wasm, zkey, Verifier.sol)

### 4️⃣ Generate Proof and Public Signals

```bash
./generate_proof.sh test
```

> This will create `proof.json` and `public.json` in `proofs/test/`

### 5️⃣ Verify Proof

```bash
./verify_proof.sh test
```

> This will check if the generated proof is valid using the verification key

---

## 🧠 System Overview (Mermaid Diagram)

```mermaid
graph TD
    A[Input JSON] --> B[Generate Witness (WASM)]
    B --> C[Generate Proof (snarkjs prove)]
    C --> D[Create Proof JSON + Public JSON]
    D --> E[Verifier Smart Contract]
    E --> F[On-chain or Local Verification]
```

---

## 📌 Notes

- Every proof generation requires entering a random text (entropy). This is expected behavior and adds randomness.
- To reset the build, you can use:

```bash
./clean_build.sh test
```

- Solidity verifier can be deployed on any EVM-compatible chain (Polygon, zkSync, etc).

---

## 📢 Future plans

- Frontend for proof generation and verification
- Deployment script for Verifier.sol
- zkEVM support and automatic deployment
- On-chain verification examples

---

## 📚 Resources

- [Circom Documentation](https://docs.circom.io/)
- [snarkjs GitHub](https://github.com/iden3/snarkjs)
- [zkSNARKs explained](https://zokrates.github.io/introduction.html)

---

## 🤝 Contributing

This project is under active development and open for improvements or suggestions.  
Feel free to open issues or contribute.