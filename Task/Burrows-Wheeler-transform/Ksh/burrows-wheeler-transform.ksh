#!/bin/ksh

# Burrows–Wheeler transform

#	# Variables:
#
export LC_COLLATE=POSIX

STX=\^		# start marker
ETX=\|		# end marker

typeset -a str
str[0]='BANANA'
str[1]='appellee'
str[2]='dogwood'
str[3]='TO BE OR NOT TO BE OR WANT TO BE OR NOT?'
str[4]='SIX.MIXED.PIXIES.SIFT.SIXTY.PIXIE.DUST.BOXES'
str[5]='|ABC^'

#	# Functions:
#

#	# Function _bwt(str, arr, lc) - sort all circular shifts of arr, return last col
#
function _bwt {
	typeset _str ; _str="$1"
	typeset _arr ; nameref _arr="$2"
	typeset _lastcol ; nameref _lastcol="$3"
	typeset _i _j _newstr ; integer _i _j

	[[ ${_str} == *+("$STX"|"$ETX")* ]] && return 1
	
	_str="$STX${_str}$ETX"
	for ((_i=0; _i<${#_str}; _i++)); do
		_newstr=${_str:${#_str}-1:1}
		for ((_j=0; _j<${#_str}-1; _j++)); do
			_newstr+=${_str:${_j}:1}
		done
		_arr+=( "${_newstr}" )
		_str="${_newstr}"
	done

	set -sA arr		# Sort arr

	for ((_i=0; _i<${#_arr[*]}; _i++)); do
		_lastcol+=${_arr[_i]:${#_arr[_i]}-1:1}
	done
}

#	# Function _ibwt(str) - inverse bwt
#
function _ibwt {
	typeset _str ; _str="$1"
	typeset _arr _vec _ret _i ; typeset -a _arr _vec ; integer _i

	_intovec "${_str}" _vec
	for ((_i=1; _i<${#_str}; _i++)); do
		_intoarr _vec _arr
		set -sA _arr
	done

	for ((_i=0; _i<${#arr[*]}; _i++)); do
		[[ "${arr[_i]}" == ${STX}*${ETX} ]] && echo "${arr[_i]}" && return
	done
}

#	# Function _intovec(str, vec) - trans str into vec[]
#
function _intovec {
	typeset _str ; _str="$1"
	typeset _vec ; nameref _vec="$2"
	typeset _i ; integer _i

	for ((_i=0; _i<${#_str}; _i++)); do
		_vec+=( "${_str:${_i}:1}" )
	done
}

#	# Function _intoarr(i, vec, arr) - insert vec into arr
#
function _intoarr {
	typeset _vec ; nameref _vec="$1"
	typeset _arr ; nameref _arr="$2"
	typeset _j ; integer _j

	for ((_j=0; _j<${#_vec[*]}; _j++)); do
		_arr="${_vec[_j]}${_arr[_j]}"
	done
}

 ######
# main #
 ######

for ((i=0; i<${#str[*]}; i++)); do
	unset arr lastcol result ; typeset -a arr

	print -- "${str[i]}"
	_bwt "${str[i]}" arr lastcol
	(( $? )) && print "ERROR: string cannot contain $STX or $ETX" && continue

	print -- "${lastcol}"
	result=$(_ibwt "${lastcol}")
	print -- "${result}"
	echo
done
