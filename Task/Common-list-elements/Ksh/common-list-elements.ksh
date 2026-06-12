#!/bin/ksh

# Find the common list elements in an integer array nums[][]

#	# Variables:
#
typeset -a nums=( (2 5 1 3 8 9 4 6) (3 5 6 2 9 8 4) (1 3 7 6 9) )

#	# Functions:
#

#	# Function _flatten(arr[][] arr[]) - flatten input matrix
#
function _flatten {
	typeset _inarr ; nameref _inarr="$1"
	typeset _outarr ; nameref _outarr="$2"
	typeset _i ; integer _i

	_oldIFS=$IFS ; IFS=\|
	for ((_i=1; _i<${#_inarr[*]}; _i++)); do
		_outarr[_i]=${_inarr[_i][*]}
	done
	IFS=$oldIFS
}

 ######
# main #
 ######

typeset -a flatarr output

_flatten nums flatarr

integer i j
for ((i=0; i<${#nums[0][*]}; i++)); do
	integer cnt=0
	for ((j=1; j<=${#flatarr[*]}; j++)); do
		[[ ${nums[0][i]} == @(${flatarr[j]%\|}) ]] && (( cnt++ ))
	done
	(( cnt == 2 )) && output+=( ${nums[0][i]} )
done

print "( ${output[@]} )"
