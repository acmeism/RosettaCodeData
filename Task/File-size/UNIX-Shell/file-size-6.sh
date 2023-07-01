#!/bin/sh
unset PATH # No cheating!

countbytes(){
	size=0

	# Read the lines in the file
	while read -r;do
		size=$((size+${#REPLY}+1)) # +1 to account for the newline
	done < "$1"
	size=$((size+${#REPLY})) # Account for partial lines

	echo "$size $1"
}

countbytes input.txt
countbytes /input.txt
