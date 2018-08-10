#! /bin/bash
set -e

image=$1

if [ "$IN_CONTAINER" != "true" ] ; then
    # Run the test script within the container
    docker run --rm \
        -e IN_CONTAINER=true \
        -e SKIP_ON_START=true \
        -v "$(pwd)/test.sh:/test.sh" \
        $image \
        bash -c "/test.sh"
else
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

    echo "Verify deleted..."
    test -f /data/test.txt && exit 1 || echo "Gone"

    echo "Restore backup..."
    /restore.sh

    echo "Verify restore..."
    test -f /data/test.txt
    cat /data/test.txt

    echo "Verify backup..."
    /verify.sh

    echo "Delete test data again..."
    rm -fr /data/*

    echo "Verify deleted..."
    test -f /data/test.txt && exit 1 || echo "Gone"

    echo "Simulate a restart with RESTORE_ON_EMPTY_START..."
    RESTORE_ON_EMPTY_START=true /start.sh

    echo "Verify restore happened..."
    test -f /data/test.txt
    cat /data/test.txt

    echo "Verify restore with incorrect passphrase fails..."
    echo "Fail to restore backup..."
    PASSPHRASE=Incorrect.Mule.Solar.Paperclip /restore.sh && exit 1 || echo "OK"
fi
