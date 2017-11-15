#! /bin/bash
set -e

echo "Performing backup tests"

echo "Create test data..."
mkdir -p /data && echo Test > /data/test.txt

echo "Making backup..."
/backup.sh

echo "Verify backup..."
/verify.sh

echo "Delete test data..."
rm -fr /data/*

echo "Restore backup..."
/restore.sh

echo "Verify backup..."
/verify.sh
