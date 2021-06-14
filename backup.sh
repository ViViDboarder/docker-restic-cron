#! /bin/bash
set -e

# Run pre-backup scripts
for f in /scripts/backup/before/*; do
    if [ -f "$f" ] && [ -x "$f" ]; then
        bash "$f"
    fi
done

# shellcheck disable=SC2086
restic \
    -r "$BACKUP_DEST" \
    $OPT_ARGUMENTS \
    backup \
    "$PATH_TO_BACKUP"

if [ -n "$CLEANUP_COMMAND" ]; then
    # Clean up old snapshots via provided policy
    # shellcheck disable=SC2086
    restic \
        -r "$BACKUP_DEST" \
        forget \
        $CLEANUP_COMMAND

    # Verify that nothing is corrupted
    restic check -r "$BACKUP_DEST"
fi

# Run post-backup scripts
for f in /scripts/backup/after/*; do
    if [ -f "$f" ] && [ -x "$f" ]; then
        bash "$f"
    fi
done
