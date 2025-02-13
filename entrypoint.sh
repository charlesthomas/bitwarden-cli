#!/bin/bash

set -euo pipefail

bw config server "${BW_HOST}"

BW_SESSION=$(bw login "${BW_USER}" --passwordenv BW_PASSWORD --raw)
export BW_SESSION

bw unlock --check

echo "Running \`bw server\` on port 8087"
exec bw serve --hostname 0.0.0.0 #--disable-origin-protection
