#! /bin/bash
set -e

# Run pre-backup scripts
for f in /scripts/backup/before/*; do
    if [ -f $f -a -x $f ]; then
        bash $f
    fi
done

restic \
    -r $BACKUP_DEST \
    $OPT_ARGUMENTS \
    backup \
    "$PATH_TO_BACKUP"

if [ -n "$CLEANUP_COMMAND" ]; then
    restic \
        -r $BACKUP_DEST \
        forget \
        $CLEANUP_COMMAND
fi

# Run post-backup scripts
for f in /scripts/backup/after/*; do
    if [ -f $f -a -x $f ]; then
        bash $f
    fi
done
