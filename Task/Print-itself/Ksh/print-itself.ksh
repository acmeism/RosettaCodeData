#!/bin/ksh

# Program to print it's own source code

 ######
# main #
 ######
while read line; do
	print "${line}"
done < $0
