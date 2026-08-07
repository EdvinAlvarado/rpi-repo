#!/bin/bash
set -e

REPO_DIR="/srv/rpi-repo"
CONF_DIR="$REPO_DIR/conf"
GPG_HOME="$REPO_DIR/.gnupg"

export GNUPGHOME="$GPG_HOME"

mkdir -p "$REPO_DIR"/{conf,dists,pool}

# Generate GPG key if missing
if [ ! -f "$GPG_HOME/trustdb.gpg" ]; then
    mkdir -p "$GPG_HOME"
    chmod 700 "$GPG_HOME"

    cat > "$GPG_HOME/gen-key.conf" <<EOF
%no-protection
Key-Type: RSA
Key-Length: 4096
Subkey-Type: RSA
Subkey-Length: 4096
Name-Real: Raspberry Pi Local Repo
Name-Email: rpi-repo@local
Expire-Date: 0
%commit
EOF

    gpg --batch --gen-key "$GPG_HOME/gen-key.conf"
    rm "$GPG_HOME/gen-key.conf"

    KEY_ID=$(gpg --list-keys --with-colons | grep fpr | head -1 | cut -d: -f10)
    gpg --armor --export "$KEY_ID" > "$REPO_DIR/public.key"
    echo "Generated GPG key: $KEY_ID"
fi

# Set ultimate trust on the repo key (idempotent)
KEY_ID=$(gpg --list-keys --with-colons | grep fpr | head -1 | cut -d: -f10)
echo "$KEY_ID:5:" | gpg --import-ownertrust

# Re-export public key
gpg --armor --export "$KEY_ID" > "$REPO_DIR/public.key"

# Create distributions config if missing
if [ ! -f "$CONF_DIR/distributions" ]; then
    cat > "$CONF_DIR/distributions" <<EOF
Origin: Raspberry Pi Local Repo
Label: rpi-local
Suite: stable
Codename: bookworm
Version: 12.0
Architectures: armhf arm64 source
Components: main
Description: Local Raspberry Pi repository
SignWith: yes
DebIndices: Packages Release . .gz
DscIndices: Sources Release . .gz
Contents: .gz
EOF
fi

# Create default options
if [ ! -f "$CONF_DIR/options" ]; then
    cat > "$CONF_DIR/options" <<EOF
verbose
basedir $REPO_DIR
ask-passphrase
EOF
fi

chmod -R a+rX "$REPO_DIR"

exec nginx -g 'daemon off;'
