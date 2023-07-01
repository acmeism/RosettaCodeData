#!/bin/ksh

# Reverse words in a string

#	# Variables:
#
typeset -a wArr
integer i


 ######
# main #
 ######

while read -A wArr; do
	for ((i=${#wArr[@]}-1; i>=0; i--)); do
		printf "%s " "${wArr[i]}"
	done
	echo
done << EOF
---------- Ice and Fire ------------

fire, in end will world the say Some
ice. in say Some
desire of tasted I've what From
fire. favor who those with hold I

... elided paragraph last ...
Frost Robert -----------------------
EOF
