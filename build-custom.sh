#!/bin/bash
# Custom RustDesk build with preconfigured server
# Server: remote.pressme.net

export RENDEZVOUS_SERVER1=remote.pressme.net
export RS_PUB_KEY_VAL="97k5t4hGqcmIccuxMg6vZMMWAIHAq4FlgugLfjE2ETA="

# macOS
if [[ "$OSTYPE" == "darwin"* ]]; then
    MACOSX_DEPLOYMENT_TARGET=10.14 cargo build --release
# Windows (Git Bash)
else
    cargo build --release
fi

echo ""
echo "Build complete. Binary at: target/release/rustdesk"
