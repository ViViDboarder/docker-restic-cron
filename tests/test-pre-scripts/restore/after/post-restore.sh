#! /bin/bash
set -e

cd /data

# Restore the backedup database
mv test_database.db.bak test_database.db
