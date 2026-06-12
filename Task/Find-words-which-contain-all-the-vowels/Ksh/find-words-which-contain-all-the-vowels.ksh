#!/bin/ksh

# Find words which contains all the vowels

#	# Variables:
#
dict='../unixdict.txt'
integer MINLENGTH=10
typeset -a vowels=( a e i o u )

#	# Functions:
#
#	# Function _allvowels(str) - return 1 if str contains all 5 vowels
#
function _allvowels {
	typeset _str ; typeset -l _str="$1"
	typeset _i ; integer _i

	for ((_i=0; _i<${#vowels[*]}; _i++)); do
		[[ ${_str} != *+(${vowels[_i]})* ]] && return 0
		[[ ${_str/${vowels[_i]}/} == *+(${vowels[_i]})* ]] && return 0
	done
	return 1
}
 ######
# main #
 ######
integer i=0
while read; do
        (( ${#REPLY} <= MINLENGTH )) && continue
        _allvowels "$REPLY"
        (( $? )) && print "$((++i)). $REPLY"
done < ${dict}
