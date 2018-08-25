#!/bin/bash
# run it with ./test_protection.sh http://websitetocontact/
i=0
while [ $i -le 4000 ]
do
    echo $i
    i=`expr $i + 1`
    curl $1
done
