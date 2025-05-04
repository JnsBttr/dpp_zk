#!/bin/bash

echo "🚀 Starte vollständige DPP Setup Routine"

# Hilfsfunktion
function check_command() {
    if ! command -v "$1" &> /dev/null
    then
        return 1
    else
        return 0
    fi
}

# ----------------------------
# NVM Prüfen + Installieren
# ----------------------------
if ! command -v nvm &> /dev/null && [ ! -s "$HOME/.nvm/nvm.sh" ]; then
    echo "📦 NVM wird installiert..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
else
    echo "✅ NVM ist installiert"
fi

# Reload für aktuelle Shell (nur falls es vorher nicht geladen war)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# ----------------------------
# Node.js Prüfen + Installieren
# ----------------------------
if ! command -v node &> /dev/null; then
    echo "📦 Node.js wird installiert..."
    nvm install --lts
else
    echo "✅ Node.js ist bereits installiert"
fi

# ----------------------------
# Rust & Cargo Prüfen + Installieren
# ----------------------------
if ! command -v cargo &> /dev/null; then
    echo "📦 Rust wird installiert..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source $HOME/.cargo/env
else
    echo "✅ Rust ist bereits installiert"
fi

# Reload für aktuelle Shell (nur falls es vorher nicht geladen war)
if ! command -v cargo &> /dev/null; then
    source "$HOME/.cargo/env"
fi

# ----------------------------
# Circom Prüfen + Installieren
# ----------------------------
if ! command -v circom &> /dev/null; then
    echo "📦 Circom wird installiert..."
    cargo install --git https://github.com/iden3/circom.git --tag v2.2.2
else
    echo "✅ Circom ist bereits installiert"
fi

# ----------------------------
# Zusammenfassung & Test
# ----------------------------
echo ""
echo "✅ Prüfe finale Versionen"

echo -n "NVM Version: "
nvm --version

echo -n "Node.js Version: "
node --version

echo -n "Cargo Version: "
cargo --version

echo -n "Circom Version: "
circom --version

echo ""
echo "🎉 Fertig! Dein DPP Dev Environment ist bereit."

exit 0

