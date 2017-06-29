#! /bin/bash

image_name=$1
tag=$2

full_image="${image_name}:${tag}"
container_name="${image_name}-${tag}"

docker run -d -e CRON_SCHEDULE="0 0 12 1 1 ? *" -e SKIP_ON_START=true --name $container_name $full_image
sleep 2
docker exec $container_name sh -c "mkdir -p /data && echo Test > /data/test.txt"
docker exec $container_name /backup.sh
docker exec $container_name /verify.sh
docker stop $container_name
docker rm $container_name
