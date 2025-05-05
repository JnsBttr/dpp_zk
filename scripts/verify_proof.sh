#!/bin/bash

echo "🚀 Starte Proof Verifizierung"

CIRCUIT_NAME=$1

if [ -z "$CIRCUIT_NAME" ]; then
  echo "❗ Fehler: Bitte gib den Circuit Namen an (ohne .circom)"
  echo "➡️ Beispiel: ./verify_proof.sh test"
  exit 1
fi

PROOF_DIR="../proofs"
BUILD_DIR="../build/$CIRCUIT_NAME"

PROOF_FILE="$PROOF_DIR/proof.json"
PUBLIC_FILE="$PROOF_DIR/public.json"
VK_FILE="$BUILD_DIR/verification_key.json"

if [ ! -f "$PROOF_FILE" ]; then
  echo "❗ Fehler: Proof Datei '$PROOF_FILE' wurde nicht gefunden!"
  exit 1
fi

if [ ! -f "$PUBLIC_FILE" ]; then
  echo "❗ Fehler: Public Datei '$PUBLIC_FILE' wurde nicht gefunden!"
  exit 1
fi

if [ ! -f "$VK_FILE" ]; then
  echo "❗ Fehler: Verification Key '$VK_FILE' wurde nicht gefunden!"
  exit 1
fi

echo "✅ Dateien gefunden, starte Verifizierung..."

snarkjs groth16 verify "$VK_FILE" "$PUBLIC_FILE" "$PROOF_FILE"

if [ $? -eq 0 ]; then
  echo "🎉 Verifizierung erfolgreich. Der Proof ist gültig."
else
  echo "❌ Verifizierung fehlgeschlagen. Der Proof ist ungültig!"
fi
