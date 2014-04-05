#!/bin/bash
set -e
set -x
# Usage: ./proxy.sh molten-yearling

REDIS_HOST=10.204.203.78
SUBDOMAIN=$1
IP=$(ifconfig eth0 | sed -n 2p | cut -d ":" -f2 | cut -d " " -f10)

sleep 3

echo "Polling docker for the port"
COUNTER=1
PORT_OUT=''
while [ 1 ]; do
echo "docker port output:" 
    echo The counter is $COUNTER

PORT_OUT=$(/usr/bin/docker port devmon-$SUBDOMAIN 5000)


echo $PORT_OUT
PORT=$(echo $PORT_OUT | sed 's/.*:\([:digit:]*\)/\1/')
echo "port result"
echo $PORT
if [[ "$PORT" -ne "" ]];
then
break
fi
    sleep 1
    let COUNTER=COUNTER+1

done

curl "http://$REDIS_HOST:7379/DEL/frontend:$SUBDOMAIN.appcbtr.com"
curl "http://$REDIS_HOST:7379/RPUSH/frontend:$SUBDOMAIN.appcbtr.com/$SUBDOMAIN"
curl "http://$REDIS_HOST:7379/RPUSH/frontend:$SUBDOMAIN.appcbtr.com/http%3A%2F%2F$IP:$PORT"

curl "http://$REDIS_HOST:7379/DEL/frontend:*.$SUBDOMAIN.appcbtr.com"
curl "http://$REDIS_HOST:7379/RPUSH/frontend:*.$SUBDOMAIN.appcbtr.com/$SUBDOMAIN"
curl "http://$REDIS_HOST:7379/RPUSH/frontend:*.$SUBDOMAIN.appcbtr.com/http%3A%2F%2F$IP:$PORT"
