#!/bin/ksh

# Variadic function

#	# Variables:
#
typeset -a arr=( 0 2 4 6 8 )

#	# Functions:
#
function _variadic {
	while [[ -n $1 ]]; do
		print $1
		shift
	done
}

 ######
# main #
 ######

_variadic Mary had a little lamb
echo
_variadic ${arr[@]}
