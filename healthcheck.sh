#! /bin/bash

HEALTH_FILE=/unhealthy

test -f $HEALTH_FILE || exit 0 && exit 1
