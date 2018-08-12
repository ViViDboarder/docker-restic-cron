#! /bin/bash
set -e

restic \
    -r $BACKUP_DEST \
    $OPT_ARGUMENTS \
    backup \
    $PATH_TO_BACKUP

if [ -n "$CLEANUP_COMMAND" ]; then
    restic \
        -r $BACKUP_DEST \
        forget \
        $CLEANUP_COMMAND
fi
