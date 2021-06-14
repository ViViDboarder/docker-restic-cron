#! /bin/bash

ENV=/env.sh
LOG=/cron.log
HEALTH_FILE=/unhealthy

if [ -f "$ENV" ]; then
    # shellcheck disable=SC1090
    source "$ENV"
fi

# Execute command and write output to log
if eval "$@" 2>> "$LOG"; then
    rm -f "$HEALTH_FILE"
else
    touch "$HEALTH_FILE"
    exit 1;
fi
