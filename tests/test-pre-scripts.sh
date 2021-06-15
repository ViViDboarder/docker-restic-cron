#! /bin/bash
set -e

image="$1"

if [ "$IN_CONTAINER" != "true" ] ; then
    # Run the test script within the container
    docker run --rm \
        -e IN_CONTAINER=true \
        -e SKIP_ON_START=true \
        -e RESTIC_PASSWORD="Correct.Horse.Battery.Staple" \
        -v "$(pwd)/test-pre-scripts.sh:/test.sh" \
        -v "$(pwd)/test-pre-scripts/backup:/scripts/backup" \
        -v "$(pwd)/test-pre-scripts/restore:/scripts/restore" \
        -v "$(pwd)/test-pre-scripts/create-test-data.sql:/scripts/create-test-data.sql" \
        "$image" \
        bash -c "/test.sh"
else
    echo "Performing backup tests"

    echo "Verify cron and crontab exist"
    type crond
    type crontab

    echo "Install sqlite3"
    apk add sqlite

    echo "Create test data..."
    mkdir -p /data
    touch /data/test_database.db
    sqlite3 /data/test_database.db < /scripts/create-test-data.sql

    echo "Fake a start and init repo"
    CRON_SCHEDULE="" /scripts/start.sh

    echo "Making backup..."
    /scripts/backup.sh

    echo "Verify intermediary file is gone"
    test -f /data/test_database.db.bak && exit 1 || echo "Gone"

    echo "Delete test data..."
    rm -fr /data/*

    echo "Verify deleted..."
    test -f /data/test_database.db && exit 1 || echo "Gone"

    echo "Restore backup..."
    /scripts/restore.sh latest

    echo "Verify restored files exist..."
    test -f /data/test_database.db
    test -f /data/test_database.db.bak && exit 1 || echo "Gone"
    sqlite3 /data/test_database.db "select data from test_table where id = 1"

    echo "Delete test data again..."
    rm -fr /data/*

    echo "Verify deleted..."
    test -f /data/test_database.db && exit 1 || echo "Gone"

    echo "Simulate a restart with RESTORE_ON_EMPTY_START..."
    RESTORE_ON_EMPTY_START=true /scripts/start.sh

    echo "Verify restore happened..."
    test -f /data/test_database.db
    test -f /data/test_database.db.bak && exit 1 || echo "Gone"
    sqlite3 /data/test_database.db "select data from test_table where id = 1"

    echo "Delete test data..."
    rm -fr /data/*

    echo "Verify restore with incorrect passphrase fails..."
    echo "Fail to restore backup..."
    RESTIC_PASSWORD=Incorrect.Mule.Solar.Paperclip /scripts/restore.sh latest && exit 1 || echo "OK"
fi
