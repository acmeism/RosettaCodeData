#!/bin/ksh

# Sort numbers lexicographically

#	# Variables:
#
integer N=${1:-13}

#	# Functions:
#

#	# Function _fillarray(arr, N) - fill assoc. array 1 -> N
#
function _fillarray {
	typeset _arr ; nameref _arr="$1"
	typeset _N ; integer _N=$2
	typeset _i _st _en ; integer _i _st _en

	(( ! _N )) && _arr=0 && return
	(( _N<0 )) && _st=${_N} && _en=1
	(( _N>0 )) && _st=1 && _en=${_N}

	for ((_i=_st; _i<=_en; _i++)); do
		_arr[${_i}]=${_i}
	done
}

 ######
# main #
 ######

set -a -s -A arr
typeset -A arr
_fillarray arr ${N}

print -- ${arr[*]}
