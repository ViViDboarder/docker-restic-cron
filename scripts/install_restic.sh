#! /bin/bash
set -ex

VERSION="$1"
ARCH="$2"

RESTIC_NAME=restic_${VERSION}_linux_${ARCH}

# Download
curl -L -o restic.bz2 "https://github.com/restic/restic/releases/download/v${VERSION}/${RESTIC_NAME}.bz2"

# Install
bunzip2 -v restic.bz2
mv restic /usr/local/bin/
chmod +x /usr/local/bin/restic
