#!/bin/ksh

# Strong and weak primes
#	# Find and display (on one line) the first   36 strong  primes.
#	# Find and display the count of the strong primes below 1,000,000.
#	# Find and display the count of the strong primes below 10,000,000.
#	# Find and display (on one line) the first   37 weak  primes.
#	# Find and display the count of the weak primes below 1,000,000.
#	# Find and display the count of the weak primes below 10,000,000.
#	# (Optional) display the counts and "below numbers" with commas. ???

#	# A strong prime is when prime[p] > (prime[p-1] + prime[p+1]) ÷ 2
#	# A  weak prime  is when prime[p] < (prime[p-1] + prime[p+1]) ÷ 2
#	# Balanced prime is when prime[p] = (prime[p-1] + prime[p+1]) ÷ 2

#	# Variables:
#
integer  NUM_STRONG=36 NUM_WEAK=37 GOAL1=1000000 MAX_INT=10000000

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

#	# Function _strength(prime[n], prime[n-1], prime[n+1]) return 1 for strong
#
function _strength {
	typeset _pri ; integer _pri=$1		# PRIme number under consideration
	typeset _pre ; integer _pre=$2		# PREvious prime number
	typeset _nex ; integer _nex=$3		# NEXt prime number
	typeset _result ; typeset -F1 _result

	(( _result = (_pre + _nex) / 2.0 ))
	(( _pri > _result )) && echo STRONG && return 0
	(( _pri < _result )) && echo WEAK   && return 1
	echo BALANCED && return 99
}

 #####
# main #
 ######

integer spcnt=0 wpcnt=0 bpcnt=0 sflg=0 wflg=0 i j k goal1_strong goal1_weak
typeset -C prime	# prime[].val  prime[].typ
	typeset -a prime.val
	typeset -a prime.typ
prime.typ[0]='NA' ; prime.typ[1]='NA'

for (( i=2; i<MAX_INT; i++ )); do
	_isprime ${i} ; (( ! $? )) && continue
	prime.val+=( ${i} )
	(( ${#prime.val[*]} <= 2 )) && continue

	(( j = ${#prime.val[*]} - 2 )) ; (( k = j - 1 ))
	prime.typ+=( $(_strength ${prime.val[${j}]} ${prime.val[k]} ${prime.val[-1]}) )
	case $? in
		 0)	(( spcnt++ ))
			(( spcnt <= NUM_STRONG )) && strbuff+="${prime.val[j]}, "
			(( i >= GOAL1 )) && (( ! sflg )) && (( goal1_strong = spcnt - 1 )) && (( sflg = 1 ))
		 ;;

		 1) (( wpcnt++ ))
			(( wpcnt <= NUM_WEAK )) && weabuff+="${prime.val[j]}, "
			(( i >= GOAL1 )) && (( ! wflg )) && (( goal1_weak = wpcnt - 1 )) && (( wflg = 1 ))
		 ;;

		99)	(( bpcnt++ ))
		 ;;
	esac
done

printf "Total primes under %d = %d\n\n"				$MAX_INT	${#prime.val[*]}
printf "First %d Strong Primes are: %s\n\n"			$NUM_STRONG	"${strbuff%,*}"
printf "Number of Strong Primes under %d  is: %d\n"		$GOAL1		${goal1_strong}
printf "Number of Strong Primes under %d is: %d\n\n\n"		$MAX_INT	${spcnt}
printf "First %d Weak Primes are: %s\n\n"			$NUM_WEAK	"${weabuff%,*}"
printf "Number of Weak Primes under %d  is: %d\n"		$GOAL1		${goal1_weak}
printf "Number of Weak Primes under %d is: %d\n\n\n"		$MAX_INT	${wpcnt}
printf "Number of Balanced Primes under %d is: %d\n\n\n"	$MAX_INT	${bpcnt}
