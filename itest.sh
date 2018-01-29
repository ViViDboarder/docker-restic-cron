#! /bin/bash
set -e

echo "Performing backup tests"

echo "Verify cron and crontab exist"
type cron
type crontab

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

echo "Verify incorrect passphrase fails..."
export PASSPHRASE=Incorrect.Mule.Solar.Paperclip

echo "Fail to restore backup..."
/restore.sh && exit 1 || echo "OK"
