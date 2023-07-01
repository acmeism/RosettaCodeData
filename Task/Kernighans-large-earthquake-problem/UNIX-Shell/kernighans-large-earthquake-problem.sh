#!/bin/bash
while read line
do
    [[ ${line##* } =~ ^([7-9]|6\.0*[1-9]).*$ ]] && echo "$line"
done < data.txt
