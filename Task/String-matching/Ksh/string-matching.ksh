#!/bin/ksh
exec 2> /tmp/String_matching.err

# String matching
#	# 1. Determine if the first string starts with second string.
#	# 2. Determine if the first string contains the second string at any location
#	# 3. Determine if the first string ends with the second string
#	# 4. Print the location of the match for part 2
#	# 5. Handle multiple occurrences of a string for part 2

#	# Variables:
#
typeset -a bounds=( [0]="no Match" [1]="Starts with" [255]="Ends with" )

typeset -a string=( "Hello" "hello world" "William Williams" "Yabba dabba do" )
typeset -a substr=( "Hell" "Do" "abba" "Will" "orld" )

#	# Functions:
#
#	# Function _bounds(str, substr) - return 1 for starts with 255 for endswith
#
function _bounds {
	typeset _str ; _str="$1"
	typeset _sub ; _sub="$2"

	typeset _FALSE _STARTS _ENDS ; integer _FALSE=0 _STARTS=1 _ENDS=255

	[[ "${_str}" == "${_sub}"* ]] && return ${_STARTS}
	[[ "${_str}" == *"${_sub}" ]] && return ${_ENDS}
	return ${_FALSE}
}

#	# Function _contains(str, substr) - return 0 no match arr[pos1 ... posn]
#
function _contains {
	typeset _str ; _str="$1"
	typeset _sub ; _sub="$2"
	typeset _arr ; nameref _arr="$3"

	typeset _FALSE _TRUE _i _match _buff ; integer _FALSE=0 _TRUE=1 _i _match

	[[ "${_str}" != *"${_sub}"* ]] && return ${_FALSE}

	for ((_i=0; _i<=${#_str}-${#_sub}; _i++)); do
		_buff=${_str:${_i}:$((${#_str}-_i))}
		[[ ${_buff} != ${_buff#${_sub}} ]] && _arr+=( $(( _i+1 )) )
	done
	return ${_TRUE}
}

 ######
# main #
 ######

integer i j rc
typeset -a posarr

for ((i=0; i<${#string[*]}; i++)); do
	for ((j=0; j<${#substr[*]}; j++)); do
		_bounds "${string[i]}" "${substr[j]}" ; rc=$?
		print "${string[i]} ${bounds[rc]} ${substr[j]}"

		_contains "${string[i]}" "${substr[j]}" posarr ; rc=$?
		((! rc)) && print "${string[i]} ${substr[j]} ${bounds[rc]}es" && continue

		print "${string[i]} + ${substr[j]} ${#posarr[*]} matches at ${posarr[*]}"
		unset posarr ; typeset -a posarr
	done
done
