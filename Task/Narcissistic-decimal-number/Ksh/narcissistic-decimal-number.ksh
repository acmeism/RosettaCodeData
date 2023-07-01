#!/bin/ksh

# Narcissistic decimal number

#	# Variables:
#

#	# Functions:
#

#	# Function _isnarcissist(n) - return 1 if n is a narcissistic decimal number
#
function _isnarcissist {
	typeset _n ; integer _n=$1

	(( ${_n} == $(_sumpowdigits ${_n}) )) && return 1
	return 0
}

#	# Function _sumpowdigits(n) - return sum of the digits raised to #digit power
#
function _sumpowdigits {
	typeset _n ; integer _n=$1
	typeset _i ; typeset -si _i
	typeset _sum ; integer _sum=0

	for ((_i=0; _i<${#_n}; _i++)); do
		(( _sum+=(${_n:_i:1}**${#_n}) ))
	done
	echo ${_sum}
}

 ######
# main #
 ######

integer i cnt=0
for ((i=0; cnt<25; i++)); do
	_isnarcissist ${i} ; (( $? )) && printf "%3d. %d\n" $(( ++cnt ))  ${i}
done
