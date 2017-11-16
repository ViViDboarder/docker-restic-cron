#! /bin/bash

image=$1

# Run the test script within the container
docker run --rm \
    -e SKIP_ON_START=true \
    -v "$(pwd)/itest.sh:/itest.sh" \
    $image \
    bash -c "/itest.sh"
