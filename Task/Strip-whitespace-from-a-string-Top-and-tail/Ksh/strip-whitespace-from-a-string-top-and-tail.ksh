#!/bin/ksh

# Strip whitespace from a string/Top and tail

#	# Variables:
#
str=${1:-"	This is a test.   "}

#	# Functions:
#

#	# Function _striphead(str) - Return str with leading while space stripped
#
function _striphead {
	typeset _str ; _str="$1"

	echo "${_str##*(\s)}"
}


#	# Function _striptail(str) - Return str with trailing while space stripped
#
function _striptail {
	typeset _str ; _str="$1"

	while [[ ${_str} != ${_str%+(\s)} ]]; do
		_str=${_str%+(\s)}
	done
	echo "${_str}"
}

 ######
# main #
 ######

printf ">%s<  (Unstripped %d chars)\n" "${str}" ${#str}
sstr=$(_striphead "${str}")
printf ">%s<  (Strip leading (%d chars))\n" "${sstr}" $(( ${#str}-${#sstr} ))
sstr=$(_striptail "${str}")
printf ">%s<  (Strip trailing (%d chars))\n" "${sstr}" $(( ${#str}-${#sstr} ))
sstr=$(_striphead "$(_striptail "${str}")")
printf ">%s<  (Strip both (%d chars))\n" "${sstr}" $(( ${#str}-${#sstr} ))
