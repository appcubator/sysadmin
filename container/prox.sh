#!/bin/bash
set -e
# Usage: ./proxy.sh molten-yearling

REDIS_HOST=10.204.203.78
DEPID=$1
PORT=$(get_port $DEPID)
echo "Polling docker for the port"

source ../proxy.sh --source-only

proxy $DEPID "$DEPID.appcbtr.com" "$PORT"
proxy $DEPID "\*.$DEPID.appcbtr.com" "$PORT"
