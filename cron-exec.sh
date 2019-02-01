#! /bin/bash

ENV=/env
LOG=/cron.log
HEALTH_FILE=/unhealthy

test -f $ENV || echo NO_ENV=true > $ENV

# Execute command and write output to log
env `cat $ENV | xargs` $@ 2>> $LOG && rm -f $HEALTH_FILE || { touch $HEALTH_FILE; exit 1; }
