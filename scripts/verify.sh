#! /bin/bash
set -e

# shellcheck disable=SC2086
restic \
    -r "$BACKUP_DEST" \
    $OPT_ARGUMENTS \
    check
