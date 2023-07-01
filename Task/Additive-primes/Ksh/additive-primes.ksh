#!/bin/ksh

# Prime numbers for which the sum of their decimal digits are also primes

#	# Variables:
#
integer MAX_n=500

#	# Functions:
#
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

#	# Function _sumdigits(n) return sum of n's digits
#
function _sumdigits {
	typeset _n ; _n=$1
	typeset _i _sum ; integer _i _sum=0

	for ((_i=0; _i<${#_n}; _i++)); do
		(( _sum+=${_n:${_i}:1} ))
	done
	echo ${_sum}
}

 ######
# main #
 ######

integer i digsum
for ((i=2; i<MAX_n; i++)); do
	_isprime ${i} && (( ! $? )) && continue

	digsum=$(_sumdigits ${i})
	_isprime ${digsum} ; (( $? )) && printf "%4d " ${i}
done
print
