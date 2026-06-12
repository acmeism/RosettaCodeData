#!/bin/ksh

# Largest palindrome product of two 3-digit numbers

#	# Variables:
#
typeset -si MINFACT=913		# From 'Paper & Pencil' solution
typeset -si MAXFACT=999

#	# Functions:
#

#	# Function _ispalindrome(n) - return 1 for palindromic number
#
function _ispalindrome {
	typeset _n ; integer _n="$1"

	(( _n != $(_flipit ${_n}) )) && return 0
	return 1
}

#	# Function _flipit(string) - return flipped string
#
function _flipit {
	typeset _buf ; _buf="$1"
	typeset _tmp ; unset _tmp
	typeset _i ; typeset -si _i

	for (( _i=$(( ${#_buf}-1 )); _i>=0; _i-- )); do
		_tmp="${_tmp}${_buf:${_i}:1}"
	done
	echo "${_tmp}"
}

 ######
# main #
 ######

integer prod MAXPPROD=0
for (( i=MINFACT; i<=MAXFACT; i++)); do
	for (( j=MINFACT; j<=MAXFACT; j++)); do
		(( prod = i * j ))
		_ispalindrome ${prod}
		(( $? )) && (( prod > MAXPPROD )) && MAXPPROD=${prod}
	done
done

print "Largest palindrome product of two 3-digit factors = ${MAXPPROD}"
