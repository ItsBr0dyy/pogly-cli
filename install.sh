#!/bin/sh

set -eu

REPO="PoglyApp/pogly-cli"
INSTALL_DIR="${POGLY_INSTALL_DIR:-$HOME/.local/bin}"
LAUNCHER="pogly"

echo "Installing Pogly CLI..."

OS="$(uname -s)"
ARCH="$(uname -m)"

if [ "$OS" != "Linux" ]; then
    echo "Error: this installer currently only supports Linux."
    echo "Detected: $OS"
    exit 1
fi

case "$ARCH" in
    x86_64)
        ASSET="pogly"
        ;;
    *)
        echo "Error: unsupported architecture: $ARCH"
        echo "Currently supported: x86_64"
        exit 1
        ;;
esac

DOWNLOAD_URL="https://github.com/$REPO/releases/latest/download/$ASSET"

mkdir -p "$INSTALL_DIR"

echo "Downloading $ASSET..."

if command -v curl >/dev/null 2>&1; then
    curl -fL "$DOWNLOAD_URL" -o "$INSTALL_DIR/$LAUNCHER"
elif command -v wget >/dev/null 2>&1; then
    wget -O "$INSTALL_DIR/$LAUNCHER" "$DOWNLOAD_URL"
else
    echo "Error: curl or wget is required."
    exit 1
fi

chmod +x "$INSTALL_DIR/$LAUNCHER"

echo ""
echo "Pogly CLI installed successfully!"
echo ""
echo "Location:"
echo "  $INSTALL_DIR/$LAUNCHER"
echo ""

case ":${PATH:-}:" in
    *":$INSTALL_DIR:"*)
        echo "You can now run:"
        echo "  pogly --help"
        ;;
    *)
        echo "Add this directory to your PATH:"
        echo ""
        echo "  export PATH=\"$INSTALL_DIR:\$PATH\""
        echo ""
        echo "For fish:"
        echo ""
        echo "  fish_add_path $INSTALL_DIR"
        ;;
esac
