#!/bin/bash
set -e
# Examples:
#   ./proxy.sh molten-yearling
#   ./proxy.sh molten-yearling --sleep

DEPID=$1
SLEEPFLAG=$2

if [ -z "$DEPID" ]; then
    echo "First arg is deployment id"
    exit 1
fi

if [ -n "$SLEEPFLAG"]
then
    if [ "$SLEEPFLAG" != "--sleep" ]; then
        echo "What the heck is $SLEEPFLAG ? Did you mean --sleep ?"
        exit 1
    fi
    proxy $DEPID --sleep
    exit 0
fi

echo "Polling docker for the port"
PORT=$(sh get_port.sh $DEPID)

source ../proxy.sh --source-only

proxy $DEPID "$DEPID.appcbtr.com" "$PORT"
proxy $DEPID "*.$DEPID.appcbtr.com" "$PORT"
