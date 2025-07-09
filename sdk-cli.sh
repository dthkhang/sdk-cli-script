#!/bin/bash
set -e

# Detect OS for sed -i compatibility
OS_TYPE="$(uname)"
if [[ "$OS_TYPE" == "Darwin" ]]; then
    SED_INPLACE="sed -i ''"
else
    SED_INPLACE="sed -i"
fi

SDK_DIR=~/android-sdk
TOOLS_DIR=$SDK_DIR/cmdline-tools
LATEST_DIR=$TOOLS_DIR/latest
BUILD_TOOLS_VERSION=34.0.0

install_sdk() {
    SDK_ZIP="$1"
    if [ -z "$SDK_ZIP" ]; then
        echo "[!] Missing path to SDK zip file."
        echo "Usage: $0 --install /path/to/commandlinetools-xxx.zip"
        exit 1
    fi
    if [ ! -f "$SDK_ZIP" ]; then
        echo "[!] File not found: $SDK_ZIP"
        exit 1
    fi
    echo "[*] Removing old SDK if exists..."
    rm -rf "$SDK_DIR"
    echo "[*] Creating directory $LATEST_DIR ..."
    mkdir -p "$LATEST_DIR"
    echo "[*] Unzipping commandline tools..."
    unzip "$SDK_ZIP" -d "$LATEST_DIR"
    if [ -d "$LATEST_DIR/cmdline-tools" ]; then
        echo "[*] Moving contents out to avoid nested directory..."
        mv "$LATEST_DIR/cmdline-tools/"* "$LATEST_DIR/"
        rm -rf "$LATEST_DIR/cmdline-tools"
    fi
    echo "[*] Updating ~/.zshrc ..."
    grep -q 'ANDROID_HOME' ~/.zshrc || echo 'export ANDROID_HOME=$HOME/android-sdk' >> ~/.zshrc
    grep -q 'cmdline-tools/latest/bin' ~/.zshrc || echo 'export PATH=$PATH:$ANDROID_HOME/cmdline-tools/latest/bin' >> ~/.zshrc
    grep -q "build-tools/$BUILD_TOOLS_VERSION" ~/.zshrc || echo "export PATH=\$PATH:\$ANDROID_HOME/build-tools/$BUILD_TOOLS_VERSION" >> ~/.zshrc
    source ~/.zshrc
    echo "[*] Accepting licenses and installing build-tools..."
    yes | sdkmanager --licenses > /dev/null
    sdkmanager "build-tools;$BUILD_TOOLS_VERSION"
    echo "[✓] Done! Checking apksigner:"
    apksigner --version
}

uninstall_sdk() {
    echo "[*] Removing all current Android SDK..."
    rm -rf ~/android-sdk
    rm -rf ~/cmdline-tools
    $SED_INPLACE '/ANDROID_HOME/d' ~/.zshrc
    $SED_INPLACE '/cmdline-tools\/latest\/bin/d' ~/.zshrc
    $SED_INPLACE '/build-tools/d' ~/.zshrc
    echo "[✓] SDK removed and ~/.zshrc cleaned. Run 'source ~/.zshrc' to apply."
}

print_usage() {
    echo "Usage: $0 --install /path/to/commandlinetools-xxx.zip"
    echo "       $0 --uninstall"
    exit 1
}

if [ $# -eq 0 ]; then
    print_usage
fi

case "$1" in
    --install)
        install_sdk "$2"
        ;;
    --uninstall)
        uninstall_sdk
        ;;
    *)
        print_usage
        ;;
esac 