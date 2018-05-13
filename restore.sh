#! /bin/bash
set -e

(
    if ! flock -x -w $FLOCK_WAIT 200 ; then
        echo 'ERROR: Could not obtain lock. Exiting.'
        exit 1
    fi

    duplicity restore \
        --force \
        --log-file /root/duplicity.log \
        --name $BACKUP_NAME \
        $OPT_ARGUMENTS \
        $@ \
        $BACKUP_DEST \
        $PATH_TO_BACKUP
) 200>/var/lock/duplicity/.duplicity.lock
