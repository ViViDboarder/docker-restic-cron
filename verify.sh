#! /bin/bash
set -e

restic \
    -r "$BACKUP_DEST" \
    $OPT_ARGUMENTS \
    check
