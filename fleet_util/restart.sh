set -e
fleetctl stop $1
sleep 3
fleetctl start $1
