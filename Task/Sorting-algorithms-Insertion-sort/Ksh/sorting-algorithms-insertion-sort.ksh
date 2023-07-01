#!/bin/ksh

# An insertion sort in ksh

#	# Variables:
#
typeset -a arr=( 4 65 2 -31 0 99 2 83 782 1 )

#	# Functions:
#

#	# Function _insertionSort(array) - Insersion sort of array of integers
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

_insertionSort arr

printf "%s" "( "
for (( i=0; i<${#arr[*]}; i++ )); do
	printf "%d " ${arr[i]}
done
printf "%s\n" " )"
