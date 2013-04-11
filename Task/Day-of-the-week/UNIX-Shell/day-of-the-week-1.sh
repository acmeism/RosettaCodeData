#! /bin/bash

for (( i=2008; i<=2121; ++i ))
do
 date -d "$i-12-25"
done  |grep Sun

exit 0
