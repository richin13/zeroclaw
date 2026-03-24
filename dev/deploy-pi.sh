#!/usr/bin/env bash
set -euo pipefail

PI_HOST="${PI_HOST:-pi@192.168.68.59}"
TARGET="aarch64-unknown-linux-gnu"
BINS="mcp_smoke zeroclaw"

cd web && npm ci && npm run build && cd ..
cargo build --release --locked --target="$TARGET"

ssh "$PI_HOST" 'zeroclaw service stop'

# shellcheck disable=SC2086
scp $(printf "target/$TARGET/release/%s " $BINS) "$PI_HOST:~/.cargo/bin"

ssh "$PI_HOST" 'zeroclaw service restart'
