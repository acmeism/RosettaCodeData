#!/bin/ksh

# Find and show primes p such that p*q+2 is prime, where q is next prime after p and p<500

#	# Variables:
#
integer MAX_PRIME=500

typeset -a parr

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

#	# Function _neighbourprime(n) return p*q+2 if prime; 0 if not
#
function _neighbourprime {
	typeset _indx ; integer _indx=$1
	typeset _arr ; nameref _arr="$2"
	typeset _neighbor

	(( _neighbor = _arr[_indx] * _arr[_indx+1] + 2 ))
	_isprime ${_neighbor}
	(( $? )) && echo ${_neighbor} && return
	echo 0
}

 ######
# main #
 ######

for ((i=2; i<MAX_PRIME; i++)); do
	_isprime ${i} ; (( $? )) && parr+=( ${i} )
done

printf "%3s %3s %6s\n" p q p*q+2
printf "%3s %3s %6s\n" --- --- -----
for ((i=0; i<$((${#parr[*]}-1)); i++)); do
	np=$(_neighbourprime ${i} parr)
	(( np > 0 )) && printf "%3d %3d %6d\n" ${parr[i]} ${parr[i+1]} ${np}
done
