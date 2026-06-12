#!/bin/ksh

# Primes with digits in nondecreasing order

#	# Variables:
#
integer MAXPRIME=1000 MINPRIME=2

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


#	# Function _isnondecreasing(n) return 1 when digits nondecreasing
#
function _isnondecreasing {
	typeset _n ; integer _n=$1
	typeset _i ; integer _i

	(( ${#_n} < 2 )) && return 1	# Always for single digit
	for((_i=0; _i<${#_n}-1; _i++)); do
		(( ${_n:${_i}:1} > ${_n:$((_i+1)):1} )) && return 0
	done
	return 1
}

 ######
# main #
 ######

integer i cnt=0
for ((i=MINPRIME; i<MAXPRIME; i++)); do
	_isprime ${i}			&& (( ! $? )) && continue
	_isnondecreasing ${i}	&& (( ! $? )) && continue
	(( cnt++ )) && printf " %d" ${i}
done
printf "\n%d Primes with digits in nondecreasing order < %d\n" ${cnt} $MAXPRIME
