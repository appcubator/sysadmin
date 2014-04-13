#!/bin/bash
set -e
# Usage: proxy <deploy id> <domain> <port>
# Examples:
#   proxy molten-yearling molten-yearling.appcbtr.com 43534
#   proxy molten-yearling "*.molten-yearling.appcbtr.com" 43534


IP=$(ifconfig eth0 | sed -n 2p | cut -d ":" -f2 | cut -d " " -f10)
REDIS_HOST=10.204.203.78
DEPID=$1
DOMAIN=$2
PORT=$3

curl "http://$REDIS_HOST:7379/DEL/frontend:$DOMAIN"
curl "http://$REDIS_HOST:7379/RPUSH/frontend:$DOMAIN/$DEPID"
curl "http://$REDIS_HOST:7379/RPUSH/frontend:$DOMAIN/http%3A%2F%2F$IP:$PORT"
