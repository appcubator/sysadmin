#!/bin/bash
set -e

# do main stuff here
for subdomain in $(cat $1)
do
    cmd=$(echo $2 | sed "s/SUBDOMAIN/$subdomain/g")
    bash -c "$cmd"
done
# end main stuff


