#!/bin/ksh

# Increment loop index within loop body

#	# Variables:
#
integer INDX_START=42 N_PRIMES=42

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

 ######
# main #
 ######
integer i n=0
for ((i=INDX_START; n<N_PRIMES; i++)); do
	_isprime ${i}
	if (( $? )); then
		printf "%,18d is prime, %2d primes found(so far)\n" ${i} $((++n))
		(( i+=$i ))
	fi
done
