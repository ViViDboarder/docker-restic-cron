set -e

# Pretend we have some database
echo "insert foo into bar;" > /mydb.txt

# Let's dump that db
cat /mydb.txt > /data/dump.txt
