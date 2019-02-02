#! /bin/bash

ENV=/env.sh
LOG=/cron.log
HEALTH_FILE=/unhealthy

touch $ENV
source $ENV

# Execute command and write output to log
$@ 2>> $LOG && rm -f $HEALTH_FILE || { touch $HEALTH_FILE; exit 1; }
