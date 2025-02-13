#!/bin/bash

set -euo pipefail

# If the container crashed there may be a dangling config file, remove it before reconfiguring.
# Not deleting it will result in a "Logout required before server config update." error.
[ -f "${BITWARDENCLI_APPDATA_DIR}/data.json" ] && rm -f "${BITWARDENCLI_APPDATA_DIR}/data.json"
bw config server "${BW_HOST}"

BW_SESSION=$(bw login "${BW_USER}" --passwordenv BW_PASSWORD --raw)
export BW_SESSION

bw unlock --check

echo "Running \`bw server\` on port 8087"
exec bw serve --hostname 0.0.0.0 #--disable-origin-protection
