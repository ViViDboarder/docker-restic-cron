#! /bin/bash

export OPT_ARGUMENTS="$@"

if [ "$1" == "bash" ]; then
    exec "$@"
    exit 0
fi

if [ "$SKIP_ON_START" != "true" ]; then
    /backup.sh
fi

if [ -n "$CRON_SCHEDULE" ]; then
    # Export the environment to a file so it can be loaded from cron
    env | sed 's/^\(.*\)=\(.*\)$/export \1="\2"/g' > /env.sh
    # Remove some vars we don't want to keep
    sed -i '/\(HOSTNAME\|affinity\|SHLVL\|PWD\)/d' /env.sh

    # Use bash for cron
    echo "SHELL=/bin/bash" > /crontab.conf

    # Schedule the backups
    echo "$CRON_SCHEDULE source /env.sh && /backup.sh 2>> /cron.log" >> /crontab.conf
    echo "Backups scheduled as $CRON_SCHEDULE"

    if [ -n "$VERIFY_CRON_SCHEDULE" ]; then
        echo "$VERIFY_CRON_SCHEDULE source /env.sh && /verify.sh 2>> /cron.log" >> /crontab.conf
        echo "Verify scheduled as $VERIFY_CRON_SCHEDULE"
    fi

    # Add to crontab
    crontab /crontab.conf

    echo "Starting duplicity cron..."
    cron

    touch /cron.log /root/duplicity.log
    tail -f /cron.log /root/duplicity.log
fi
