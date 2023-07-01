#!/bin/ksh

# Sort disjoint sublist

#	# Variables:
#
typeset -a arr_Val=( 7 6 5 4 3 2 1 0 )
typeset -a arr_Ind=( 6 1 7 )
integer i

#	# Functions:
#
#       # Function _insertionSort(array) - Insertion sort of array of integers
#
function _insertionSort {
	typeset _arr ; nameref _arr="$1"
	typeset _i _j _val ; integer _i _j _val

	for (( _i=1; _i<${#_arr[*]}; _i++ )); do
		_val=${_arr[_i]}
		(( _j = _i - 1 ))
		while (( _j>=0 && _arr[_j]>_val )); do
			_arr[_j+1]=${_arr[_j]}
			(( _j-- ))
		done
		_arr[_j+1]=${_val}
	done
}

 ######
# main #
 ######
print "Before sort: ${arr_Val[*]}"

typeset -a arr_2sort
for ((i=0; i<${#arr_Ind[*]}; i++)); do
	arr_2sort+=( ${arr_Val[${arr_Ind[i]}]} )
done

_insertionSort arr_2sort	# Sort the chosen values
_insertionSort arr_Ind		# Sort the indices

for ((i=0; i<${#arr_Ind[*]}; i++)); do
	arr_Val[${arr_Ind[i]}]=${arr_2sort[i]}
done

print "After  sort: ${arr_Val[*]}"
