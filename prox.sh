#!/bin/bash
set -e
# Usage: ./proxy.sh molten-yearling 34532 

REDIS_HOST=10.204.203.78
SUBDOMAIN=$1
IP=$(ifconfig eth0 | sed -n 2p | cut -d ":" -f2 | cut -d " " -f10)
PORT=$2

curl "http://$REDIS_HOST:7379/DEL/frontend:$SUBDOMAIN.appcbtr.com"
curl "http://$REDIS_HOST:7379/RPUSH/frontend:$SUBDOMAIN.appcbtr.com/$ID"
curl "http://$REDIS_HOST:7379/RPUSH/frontend:$SUBDOMAIN.appcbtr.com/http%3A%2F%2F$IP:$PORT"
curl "http://$REDIS_HOST:7379/RPUSH/frontend:*.$SUBDOMAIN.appcbtr.com/http%3A%2F%2F$IP:$PORT"
