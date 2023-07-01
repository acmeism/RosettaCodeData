#!/bin/ksh

# Safe primes and unsafe primes

#	# Variables:
#
integer safecnt=0 safedisp=35 safecnt1M=0
integer unsacnt=0 unsadisp=40 unsacnt1M=0
typeset -a safeprime unsafeprime

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

#	# Function _issafe(p) return 1 for safe prime, 0 for not
#
function _issafe {
	typeset _p ; integer _p=$1

	_isprime $(( (_p - 1) / 2 ))
	return $?
}

 ######
# main #
 ######

for ((n=3; n<=10000000; n++)); do
	_isprime ${n}
	(( ! $? )) && continue
	_issafe ${n}
	if (( $? )); then
		(( safecnt++ ))
		(( safecnt < safedisp)) && safeprime+=( ${n} )
		(( n <= 999999 )) && safecnt1M=${safecnt}
	else
		(( unsacnt++ ))
		(( unsacnt < unsadisp)) && unsafeprime+=( ${n} )
		(( n <= 999999 )) && unsacnt1M=${unsacnt}
	fi
done

print "Safe primes:\n${safeprime[*]}"
print "There are ${safecnt1M} under 1,000,000"
print "There are ${safecnt} under 10,000,000\n"

print "Unsafe primes:\n${unsafeprime[*]}"
print "There are ${unsacnt1M} under 1,000,000"
print "There are ${unsacnt} under 10,000,000"
