#!/bin/ksh

# Primes which sum of digits is 25

#	# Variables:
#
integer MAXN=5000 SUM=25

#	# Functions:
#
#	# Function _sumdigits(n, sum) - return 1 if sum of n's digits = sum
#
function _sumdigits {
	typeset _n ; integer _n=$1
	typeset _sum ; integer _sum=$2
	typeset _i _dsum ; integer _i _dsum=0

	for ((_i=0; _i<${#_n}; _i++)); do
		(( _dsum+=${_n:_i:1} ))
	done
	return $(( _dsum == _sum ))
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

for ((i=3; i<$MAXN; i++)); do
	_isprime ${i} || _sumdigits ${i} $SUM || printf "%d " ${i}
done
echo
