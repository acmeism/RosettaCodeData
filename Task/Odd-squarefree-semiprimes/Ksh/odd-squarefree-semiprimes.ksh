#!/bin/ksh

# Odd squarefree semiprimes
#	# Odd numbers of the form p*q where p and q are distinct primes and p*q<1000

#	# Variables:
#
integer i j candidate cnt=0
typeset -a primes osfsp

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

#	# Function _firstNprimes(n, arr) return array of first N primes
#
function _firstNprimes {
	typeset _n ; integer _n=$1
	typeset _arr ; nameref _arr="$2"

	typeset _i _cnt ; integer _i=1 _cnt=0

	while (( _cnt <= _n )); do
		_isprime ${_i} ; (( $? )) && (( _cnt++ )) && _arr+=( ${_i} )
		(( _i++ ))
	done
}

#	# Function _isunique(n, arr) add n to array if unique to array
#
function _isunique {
	typeset _n ; integer _n=$1
	typeset _arr ; nameref _arr="$2"

	typeset _buff _oldIFS
	_oldIFS=$IFS

	IFS=\|
	_buff=${_arr[*]}
	[[ ${_n} == @(${_buff}) ]] || _arr+=( ${_n} )
	IFS=${_oldIFS}
}

#	# Function _insertionSort(array) - Insersion sort of array of integers
#
function _insertionSort {
	typeset _arr ; nameref _arr="$1"
	typeset _i _j _val ; integer _i _j _val

    for (( _i=1; _i<${#_arr[*]}; _i++ )); do
        _val=${_arr[_i]}
        (( _j = _i - 1 ))
        while (( _j>=0 && _arr[_j]>_val )); do
            _arr[_j+1]=${_arr[_j]}
            (( _j-- ))
        done
        _arr[_j+1]=${_val}
    done
}
 ######
# main #
 ######

_firstNprimes 66 primes			# 67th prime -> 337 * 3 = 1011 > 999

for ((i=0; i<${#primes[*]}; i++)); do
	for ((j=0; j<${#primes[*]}; j++)); do
		((j == i )) && continue
		(( candidate = primes[i] * primes[j] ))
		(( candidate > 999 )) || (( ! $(( candidate & 1 )) )) && continue
		_isunique ${candidate} osfsp
	done
done

_insertionSort osfsp
print ${osfsp[*]}
echo
print "Counted ${#osfsp[*]} odd squarefree semiprimes under 1000"
