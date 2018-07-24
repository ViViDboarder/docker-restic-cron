#! /bin/bash
set -e

restore_snapshot=$1

restic \
    -r $BACKUP_DEST \
    $OPT_ARGUMENTS \
    restore \
    $restore_snapshot \
    -t /
