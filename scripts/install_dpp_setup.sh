#!/bin/bash

echo "🚀 Starte Setup Routine für DPP zk Projekt"

# NVM Installation prüfen
if ! command -v nvm &> /dev/null
then
    echo "📦 NVM wird installiert..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
    echo "✅ NVM ist installiert"
fi

# Node Installation prüfen
if ! command -v node &> /dev/null
then
    echo "📦 Node.js wird installiert..."
    nvm install --lts
else
    echo "✅ Node.js ist bereits installiert"
fi

# Rust / Cargo Installation prüfen
if ! command -v cargo &> /dev/null
then
    echo "📦 Rust & Cargo werden installiert"
    curl https://sh.rustup.rs -sSf | sh -s -- -y
    source "$HOME/.cargo/env"
else
    echo "✅ Rust & Cargo sind bereits installiert"
fi

# Circom Installation prüfen
if ! command -v circom &> /dev/null
then
    echo "📦 Circom wird installiert"
    cargo install --git https://github.com/iden3/circom.git --locked
else
    echo "✅ Circom ist bereits installiert"
fi

# SnarkJS Installation prüfen
if ! command -v snarkjs &> /dev/null
then
    echo "📦 SnarkJS wird installiert"
    npm install -g snarkjs
else
    echo "✅ SnarkJS ist bereits installiert"
fi

echo "🎉 Setup abgeschlossen."
echo "📜 Bitte die README.md Datei für weitere Anweisungen lesen."