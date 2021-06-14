#! /bin/bash
set -e

restore_snapshot="$1"

# Run pre-restore scripts
for f in /scripts/restore/before/*; do
    if [ -f "$f" ] && [ -x "$f" ]; then
        bash "$f"
    fi
done

# shellcheck disable=SC2086
restic \
    -r "$BACKUP_DEST" \
    $OPT_ARGUMENTS \
    restore \
    "$restore_snapshot" \
    -t /

# Run post-restore scripts
for f in /scripts/restore/after/*; do
    if [ -f "$f" ] && [ -x "$f" ]; then
        bash "$f"
    fi
done
