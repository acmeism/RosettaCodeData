#!/bin/ksh

# Positive decimal integers with the digit 1 occurring twice

#	# Variables:
#
integer MAX=999

#	# Functions:
#


 ######
# main #
 ######

for ((i=10; i<MAX; i++)); do
	[[ ${i} == *{2}(1)* ]] && printf "%d " ${i}
done
echo
