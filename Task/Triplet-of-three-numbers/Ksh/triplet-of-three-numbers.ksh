#!/bin/ksh

# numbers n such that n-1, n+3, and n+5 are all prime where: n < 6,000.

#	# Variables:
#
integer MAX_n=6000

#	# Functions:
#

#	# Function _triplet(n, arr) build array of n-1, n+3, n+5
#
function _triplet {
	typeset _n ; integer _n=$1
	typeset _arr ; nameref _arr="$2"

	_arr=( $((_n-1)) $((_n+3)) $((_n+5)) )
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

for ((i=2; i<MAX_n; i++)); do
	typeset -a arr
	_triplet ${i} arr
	for ((j=0; j<${#arr[*]}; j++)); do
		_isprime ${arr[j]}
		(( ! $? )) && unset arr && continue 2
	done
	oldIFS=${IFS}
	IFS=\,
	print "${i}: ${arr[*]}"
	IFS=${oldIFS}
	unset arr
done
