#! /bin/bash
set -e

duplicity \
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
