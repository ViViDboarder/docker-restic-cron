set -e

cd /data

# Dump the SQLite database
sqlite3 test_database.db ".backup test_database.db.bak"
