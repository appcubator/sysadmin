#!/bin/bash
set -e

# TEMP DIRECTORY CODE FROM http://stackoverflow.com/questions/2472629/temporary-operation-in-a-temporary-directory-in-shell-script
TDIR=`mktemp -d`
trap "{ cd - ; rm -rf $TDIR; exit 255; }" SIGINT
cp hostnames.txt $TDIR
cd $TDIR



# do main stuff here
for subdomain in $(cat hostnames.txt)
do
    cmd=$(echo $1 | sed "s/SUBDOMAIN/$subdomain/")
    echo $cmd
done
# end main stuff



# cleanup temp directory
cd -
rm -rf $TDIR

