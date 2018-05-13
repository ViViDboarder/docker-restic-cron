#! /bin/bash
set -e

(
    if ! flock -x -w $FLOCK_WAIT 200 ; then
        echo 'ERROR: Could not obtain lock. Exiting.'
        exit 1
    fi

    duplicity \
        $1 \
        --asynchronous-upload \
        --log-file /root/duplicity.log \
        --name $BACKUP_NAME \
        $OPT_ARGUMENTS \
        $PATH_TO_BACKUP \
        $BACKUP_DEST

    if [ -n "$CLEANUP_COMMAND" ]; then
        duplicity $CLEANUP_COMMAND \
            --log-file /root/duplicity.log \
            --name $BACKUP_NAME \
            $BACKUP_DEST
    fi
) 200>/var/lock/duplicity/.duplicity.lock
