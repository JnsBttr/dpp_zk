#!/bin/bash

echo "🚀 Starte Proof Build Prozess"

CIRCUIT_NAME=$1

# Prüfen ob Circuit Name übergeben wurde
if [ -z "$CIRCUIT_NAME" ]; then
  echo "❗ Fehler: Bitte gib den Circuit Namen an (ohne .circom)"
  echo "➡️ Beispiel: ./build_proof.sh test"
  exit 1
fi

# Circuit Datei prüfen
CIRCUIT_FILE="../circuits/${CIRCUIT_NAME}.circom"

if [ ! -f "$CIRCUIT_FILE" ]; then
  echo "❗ Fehler: Circuit Datei '${CIRCUIT_FILE}' wurde nicht gefunden!"
  exit 1
fi

# Build Verzeichnis erstellen
BUILD_DIR="../build/$CIRCUIT_NAME"
mkdir -p "$BUILD_DIR"

echo "✅ Circuit kompilieren..."
circom "$CIRCUIT_FILE" --r1cs --wasm --sym -o "$BUILD_DIR"

echo "✅ Powersoftau new starten..."
snarkjs powersoftau new bn128 12 "$BUILD_DIR/pot12_0000.ptau" -v

echo "✅ Powersoftau contribution leisten..."
snarkjs powersoftau contribute "$BUILD_DIR/pot12_0000.ptau" "$BUILD_DIR/pot12_0001.ptau" --name="First contribution" -v

echo "✅ Powersoftau vorbereiten (prepare phase2)..."
snarkjs powersoftau prepare phase2 "$BUILD_DIR/pot12_0001.ptau" "$BUILD_DIR/pot12_final.ptau"

echo "✅ ZKey erzeugen (groth16 setup)..."
snarkjs groth16 setup "$BUILD_DIR/$CIRCUIT_NAME.r1cs" "$BUILD_DIR/pot12_final.ptau" "$BUILD_DIR/${CIRCUIT_NAME}_0000.zkey"

echo "✅ ZKey contribution..."
snarkjs zkey contribute "$BUILD_DIR/${CIRCUIT_NAME}_0000.zkey" "$BUILD_DIR/${CIRCUIT_NAME}_final.zkey" --name="1st Contributor" -v

echo "✅ Solidity Verifier generieren..."
snarkjs zkey export solidityverifier "$BUILD_DIR/${CIRCUIT_NAME}_final.zkey" "$BUILD_DIR/Verifier.sol"

echo "✅ Verification Key generieren..."
snarkjs zkey export verificationkey "$BUILD_DIR/${CIRCUIT_NAME}_final.zkey" "$BUILD_DIR/verification_key.json"

echo "🎉 Proof Build abgeschlossen. Verifier.sol ist bereit in $BUILD_DIR"
echo "📜 Bitte die README.md Datei für weitere Anweisungen lesen."
