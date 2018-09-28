#! /bin/bash
set -e

image=$1

if [ "$IN_CONTAINER" != "true" ] ; then
    # Run the test script within the container
    docker run --rm \
        -e IN_CONTAINER=true \
        -e SKIP_ON_START=true \
        -v "$(pwd)/test-pre-scripts.sh:/test.sh" \
        -v "$(pwd)/scripts/pre-backup.sh:/scripts/backup/before/1.sh" \
        -v "$(pwd)/scripts/post-backup.sh:/scripts/backup/after/1.sh" \
        -v "$(pwd)/scripts/pre-restore.sh:/scripts/restore/before/1.sh" \
        -v "$(pwd)/scripts/post-restore.sh:/scripts/restore/after/1.sh" \
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

    echo "Delete test data..."
    rm -fr /data/*
    rm -fr /mydb.txt

    echo "Verify deleted..."
    test -f /data/test.txt && exit 1 || echo "Gone"
    test -f /mydb.txt && exit 1 || echo "Gone"

    echo "Restore backup..."
    /restore.sh

    echo "Verify pre-post script backups..."
    test -f /mydb.txt
    cat /mydb.txt

    echo "Delete test data again..."
    rm -fr /data/*
    rm -fr /mydb.txt

    echo "Verify deleted..."
    test -f /data/test.txt && exit 1 || echo "Gone"
    test -f /mydb.txt && exit 1 || echo "Gone"

    echo "Simulate a restart with RESTORE_ON_EMPTY_START..."
    RESTORE_ON_EMPTY_START=true /start.sh

    echo "Verify restore happened..."
    test -f /data/test.txt
    cat /data/test.txt

    echo "Verify pre-post script backups..."
    test -f /mydb.txt
    cat /mydb.txt

    echo "Verify restore with incorrect passphrase fails..."
    echo "Fail to restore backup..."
    PASSPHRASE=Incorrect.Mule.Solar.Paperclip /restore.sh && exit 1 || echo "OK"
fi
