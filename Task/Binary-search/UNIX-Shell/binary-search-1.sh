#!/bin/ksh
# This should work on any clone of Bourne Shell, ksh is the fastest.

value=$1; [ -z "$value" ] && exit
array=()
size=0

while IFS= read -r line; do
	size=$(($size + 1))
	array[${#array[*]}]=$line
done
