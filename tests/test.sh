#! /bin/bash
set -e

image=$1

if [ "$IN_CONTAINER" != "true" ] ; then
    # Run the test script within the container
    docker run --rm \
        -e IN_CONTAINER=true \
        -e SKIP_ON_START=true \
        -e RESTIC_PASSWORD="Correct.Horse.Battery.Staple" \
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

    echo "Fake a start and init repo"
    CRON_SCHEDULE="" /start.sh

    echo "Making backup..."
    /backup.sh

    echo "Verify backup..."
    /verify.sh

    echo "Delete test data..."
    rm -fr /data/*

    echo "Verify deleted..."
    test -f /data/test.txt && exit 1 || echo "Gone"

    echo "Restore backup..."
    /restore.sh latest

    echo "Verify restore..."
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
    cat /data/test.txt

    echo "Verify restore with incorrect passphrase fails..."
    echo "Fail to restore backup..."
    RESTIC_PASSWORD=Incorrect.Mule.Solar.Paperclip /restore.sh latest && exit 1 || echo "OK"
fi
