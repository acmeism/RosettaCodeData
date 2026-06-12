#!/bin/ksh

# Quadrat Special Primes

#	# Variables:
#
alias SHORTINT='typeset -si'
SHORTINT MAXN=16000

#	# Functions:
#

#	# Function _isquadrat(n, m) return 1 when (m-n) is a perfect square
#
function _isquadrat {
	typeset _n ; SHORTINT _n=$1
	typeset _m ; SHORTINT _m=$2

	[[ $(( sqrt(_m - _n) )) == +(\d).+(\d) ]] && return 0
	return 1
}

#	# Function _isprime(n) return 1 for prime, 0 for not prime
#
function _isprime {
	typeset _n ; integer _n=$1
	typeset _i ; integer _i

	(( _n < 2 )) && return 0
	for (( _i=2 ; _i*_i<=_n ; _i++ )); do
		(( ! ( _n % _i ) )) && return 0
	done
	return 1
}

 ######
# main #
 ######

SHORTINT i prev_pr=2
for ((i=2; i<MAXN; i++)); do
	_isprime ${i}
	if (( $? )); then
		_isquadrat ${prev_pr} ${i}
		if (( $? )); then
			 printf "%d " ${i}
			 prev_pr=${i}
		fi
	fi
done
printf "\n"
