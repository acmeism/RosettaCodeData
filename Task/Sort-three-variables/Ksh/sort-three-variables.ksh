#!/bin/ksh

# Sort three variables that may contain any value (numbers and/or literals)

#	# Variables:
#
xl='lions, tigers, and'
yl='bears, oh my!'
zl='(from the "Wizard of OZ")'

typeset -i xn=77444
typeset -F yn=-12.0
typeset -i zn=0

#	# Functions:
#

#	# Function _intoarray(x, y, z, arr) - put 3 variables into arr[]
#
function _intoarray {
	typeset _x ; nameref _x="$1"
	typeset _y ; nameref _y="$2"
	typeset _z ; nameref _z="$3"
	typeset _arr ; nameref _arr="$4"

	_arr=( "${_x}" "${_y}" "${_z}" )
}

#	# Function _arraysort(arr) - return sorted array (any type of elements)
#
function _arraysort {
	typeset _arr ; nameref _arr="$1"
	typeset _i _j ; integer _i _j

	_sorttype _arr
	case $? in
		0)	# Literal sort
			for (( _i=1; _i<${#_arr[*]}; _i++ )); do
				_val="${_arr[_i]}"
				(( _j = _i - 1 ))
				while (( _j>=0 )) && [[ "${_arr[_j]}" > "${_val}" ]]; do
					_arr[_j+1]="${_arr[_j]}"
					(( _j-- ))
				done
				_arr[_j+1]="${_val}"
			done
		;;

		1)	# Numeric sort
			for (( _i=1; _i<${#_arr[*]}; _i++ )); do
				_val=${_arr[_i]}
				(( _j = _i - 1 ))
				while (( _j>=0 && _arr[_j]>_val )); do
					_arr[_j+1]=${_arr[_j]}
					(( _j-- ))
				done
				_arr[_j+1]=${_val}
			done
		;;
	esac
}

#	# Function _sorttype(_arr) - return 0 = Literal sort; 1 = Numeric sort
#
function _sorttype {
	typeset _arr ; nameref _arr="$1"
	typeset _i ; integer _i

	for ((_i=0; _i<${#_arr[*]}; _i++)); do
		[[ ${_arr[_i]} != *(\-)+(\d)*(\.)*(\d) ]] && return 0
	done
	return 1
}

#	# Function _outofarray(x, y, z, arr) - Put array elements into x, y, z
#
function _outofarray {
	typeset _x ; nameref _x="$1"
	typeset _y ; nameref _y="$2"
	typeset _z ; nameref _z="$3"
	typeset _arr ; nameref _arr="$4"

	_x="${_arr[0]}"
	_y="${_arr[1]}"
	_z="${_arr[2]}"
}

 ######
# main #
 ######

unset x y z
printf "Numeric Variables:\n%s\n%s\n%s\n\n" "${xn}" "${yn}" "${zn}"
typeset -a arrayn
_intoarray xn yn zn arrayn
_arraysort arrayn
_outofarray x y z arrayn
printf "Sorted Variables:\n%s\n%s\n%s\n\n" "${x}" "${y}" "${z}"

unset x y z
printf "Literal Variables:\n%s\n%s\n%s\n\n" "${xl}" "${yl}" "${zl}"
typeset -a arrayl
_intoarray xl yl zl arrayl
_arraysort arrayl
_outofarray x y z arrayl
printf "Sorted Variables:\n%s\n%s\n%s\n\n" "${x}" "${y}" "${z}"
