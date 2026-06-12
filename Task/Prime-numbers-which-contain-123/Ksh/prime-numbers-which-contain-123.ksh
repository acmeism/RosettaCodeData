#!/bin/ksh

# Prime numbers which contain 123

#	# Variables:
#
integer MAX_SHOW=100000 MAX_COUNT=1000000 primecnt=0
pattrn='123'
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


 ######
# main #
 ######

for ((i=2; i<MAX_COUNT; i++)); do
	_isprime ${i}
	if (( $? )); then
		if [[ ${i} == *${pattrn}* ]]; then
			((primecnt++))
			(( i < MAX_SHOW )) && parr+=( ${i} )
		fi
	fi
done

print ${parr[*]}
print ${#parr[*]} found under $MAX_SHOW
echo ; print ${primecnt} found under $MAX_COUNT
