#! /bin/bash
set -e

duplicity verify $BACKUP_DEST $PATH_TO_BACKUP
