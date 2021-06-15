#! /bin/bash
set -ex

VERSION="$1"
ARCH="$2"

RCLONE_NAME=rclone-${VERSION}-linux-${ARCH}

# Download
curl -o rclone.zip "https://downloads.rclone.org/${VERSION}/${RCLONE_NAME}.zip"

# Install
unzip rclone.zip
mv "${RCLONE_NAME}/rclone" /usr/local/bin/

# Clean up
rm rclone.zip
rm -fr "${RCLONE_NAME}"
