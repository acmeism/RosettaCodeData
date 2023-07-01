#!/bin/ksh

# Symmetric difference - enumerate the items that are in A or B but not both.

#	# Variables:
#
typeset -a A=( John Bob Mary Serena )
typeset -a B=( Jim Mary John Bob )

#	# Functions:
#
#	# Function _flattenarr(arr, sep) - flatten arr into string by separator sep
#
function _flattenarr {
	typeset _arr ; nameref _arr="$1"
	typeset _sep ; typeset -L1 _sep="$2"
	typeset _buff
	typeset _oldIFS=$IFS ; IFS="${_sep}"

	_buff=${_arr[*]}
	IFS="${_oldIFS}"
	echo "${_buff}"
}

#	# Function _notin(_arr1, _arr2) - elements in arr1 and not in arr2
#
function _notin {
	typeset _ar1 ; nameref _ar1="$1"
	typeset _ar2 ; nameref _ar2="$2"
	typeset _i _buff _set ; integer _i

	_buff=$(_flattenarr _ar2 \|)
	for((_i=0; _i<${#_ar1[*]}; _i++)); do
		[[ ${_ar1[_i]} != @(${_buff}) ]] && _set+="${_ar1[_i]} "
	done
	echo ${_set% *}
}

 ######
# main #
 ######

AnB=$(_notin A B) ; echo "A - B   = ${AnB}"
BnA=$(_notin B A) ; echo "B - A   = ${BnA}"
echo "A xor B = ${AnB} ${BnA}"
