#!/bin/bash
str=abcde

for((i=${#str}-1;i>=0;i--)); do rev="$rev${str:$i:1}"; done

echo $rev
