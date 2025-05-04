#!/bin/bash

echo "🚀 Starte Proof Generierung"

CIRCUIT_NAME=$1

if [ -z "$CIRCUIT_NAME" ]; then
  echo "❗ Fehler: Bitte gib den Circuit Namen an (ohne .circom)"
  echo "➡️ Beispiel: ./generate_proof.sh test"
  exit 1
fi

INPUT_FILE="../inputs/${CIRCUIT_NAME}_input.json"
WASM_FILE="../build/${CIRCUIT_NAME}/${CIRCUIT_NAME}_js/${CIRCUIT_NAME}.wasm"
ZKEY_FILE="../build/${CIRCUIT_NAME}/${CIRCUIT_NAME}_final.zkey"
PROOF_DIR="../proofs"

if [ ! -f "$INPUT_FILE" ]; then
  echo "❗ Fehler: Eingabedatei ${INPUT_FILE} nicht gefunden!"
  exit 1
fi

mkdir -p "$PROOF_DIR"

echo "✅ Generiere Proof und Public Signals..."
snarkjs groth16 fullprove "$INPUT_FILE" "$WASM_FILE" "$ZKEY_FILE" "$PROOF_DIR/proof.json" "$PROOF_DIR/public.json"

echo "🎉 Proof erfolgreich generiert in ${PROOF_DIR}"

