#! /bin/bash
set -e

# If key id is provied add arg
if [ -e "$GPG_KEY_ID" ]; then
    OPT_ARGUMENTS="$OPT_ARGUMENTS --encrypt-sign-key=\"$GPG_KEY_ID\""
fi

duplicity \
    --allow-source-mismatch \
    --asynchronous-upload \
    --log-file /root/duplicity.log \
    --name $BACKUP_NAME \
    $OPT_ARGUMENTS \
    $PATH_TO_BACKUP \
    $BACKUP_DEST

if [ -n "$CLEANUP_COMMAND" ]; then
    duplicity $CLEANUP_COMMAND \
        --log-file /root/duplicity.log \
        $BACKUP_DEST
fi
