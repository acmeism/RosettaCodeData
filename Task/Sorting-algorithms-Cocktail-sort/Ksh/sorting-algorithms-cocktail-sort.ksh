#!/bin/ksh

# cocktail shaker sort

#	# Variables:
#
integer TRUE=1
integer FALSE=0
typeset -a arr=( 5 -1 101 -4 0 1 8 6 2 3 )

#	# Functions:
#
function _swap {
	typeset _i ; integer _i=$1
	typeset _j ; integer _j=$2
	typeset _array ; nameref _array="$3"
	typeset _swapped ; nameref _swapped=$4

	typeset _tmp ; _tmp=${_array[_i]}
	_array[_i]=${_array[_j]}
	_array[_j]=${_tmp}
	_swapped=$TRUE
}

 ######
# main #
 ######

print "( ${arr[*]} )"

integer i j
integer swapped=$TRUE
while (( swapped )); do
	swapped=$FALSE
	for (( i=0 ; i<${#arr[*]}-2 ; i++ , j=i+1 )); do
		(( arr[i] > arr[j] )) && _swap ${i} ${j} arr swapped
	done
	(( ! swapped )) && break

	swapped=$FALSE
	for (( i=${#arr[*]}-2 ; i>0 ; i-- , j=i+1 )); do
		(( arr[i] > arr[j] )) && _swap ${i} ${j} arr swapped
	done
done

print "( ${arr[*]} )"
