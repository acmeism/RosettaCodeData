#!/bin/ksh

# Split a character string based on change of character

#	# Variables:
#
str='gHHH5YY++///\'
delim=', '

#	# Functions:
#
#	# Function _splitonchg(str, delim) - return str split by delim at char change
#
function _splitonchg {
	typeset _str ; _str="$1"
	typeset _delim ; _delim="$2"
	typeset _i _splitstr ; integer _i

	for ((_i=1; _i<${#_str}+1; _i++)); do
		if [[ "${_str:$((_i-1)):1}" != "${_str:${_i}:1}" ]]; then
			_splitstr+="${_str:$((_i-1)):1}${_delim}"
		else
			_splitstr+="${_str:$((_i-1)):1}"
		fi
	done
	echo "${_splitstr%"${_delim}"*}"
}

 ######
# main #
 ######

print "Original: ${str}"
print "   Split: $(_splitonchg "${str}" "${delim}")"
