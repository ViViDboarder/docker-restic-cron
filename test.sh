#! /bin/bash

image_name=$1
tag=$2

full_image="${image_name}:${tag}"
container_name="${image_name}-${tag}"

# Run the test script within the container
docker run --rm \
    -e SKIP_ON_START=true \
    -v "$(pwd)/itest.sh:/itest.sh" \
    --name ${container_name} \
    $full_image \
    bash -c "/itest.sh"
