#!/bin/bash

set -e

bw config server ${BW_HOST}

if [ -n "$BW_CLIENTID" ] && [ -n "$BW_CLIENTSECRET" ]; then
	echo "Using apikey to log in"
	bw login --apikey --raw
	export BW_SESSION=$(bw unlock --passwordenv BW_PASSWORD --raw)
else
	echo "Using username and password to log in"
	export BW_SESSION=$(bw login ${BW_USER} --passwordenv BW_PASSWORD --raw)
fi

bw unlock --check

echo 'Running `bw server` on port 8087'
bw serve --hostname all

