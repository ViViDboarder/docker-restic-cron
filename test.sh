#! /bin/bash

image_name=$1
tag=$2

full_image="${image_name}:${tag}"
container_name="${image_name}-${tag}"

# Create backup container
docker run -d -e SKIP_ON_START=true --name ${container_name} $full_image bash -c "/bin/sleep 20"
# Create some test data
docker exec $container_name sh -c "mkdir -p /data && echo Test > /data/test.txt"
# Backup data
echo "Making backup..."
docker exec $container_name /backup.sh
# Verify the backup
echo "Verify backup..."
docker exec $container_name /verify.sh
# Remove test file
echo "Clear data..."
docker exec $container_name sh -c "rm /data/*"
# Restore the backup
echo "Restore backup..."
docker exec $container_name /restore.sh
# Verify the backup
echo "Verify backup..."
docker exec $container_name /verify.sh
# Stop the container
docker kill $container_name
# Remove the container
docker rm $container_name
