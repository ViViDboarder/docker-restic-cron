#! /bin/bash
set -e

(
    if ! flock -x -w $FLOCK_WAIT 200 ; then
        echo 'ERROR: Could not obtain lock. Exiting.'
        exit 1
    fi

    # Run pre-restore scripts
    for f in /scripts/restore/before/*; do
        if [ -f $f -a -x $f ]; then
            bash $f
        fi
    done

    duplicity restore \
        --force \
        --log-file /root/duplicity.log \
        --name $BACKUP_NAME \
        $OPT_ARGUMENTS \
        $@ \
        $BACKUP_DEST \
        $PATH_TO_BACKUP

    # Run post-restore scripts
    for f in /scripts/restore/after/*; do
        if [ -f $f -a -x $f ]; then
            bash $f
        fi
    done

) 200>/var/lock/duplicity/.duplicity.lock
