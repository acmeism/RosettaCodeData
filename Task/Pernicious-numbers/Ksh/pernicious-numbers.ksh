#!/bin/ksh

# Positive integer whose population count is a prime

#	# Variables:
#
integer PNUM=25 MINN=888888877 MAXN=888888888

#	# Functions:
#
#	# Function _dec2bin(n) - return binary representation of decimal n
#
function _dec2bin {
	typeset _n ; integer _n=$1
	typeset _base ; integer _base=2
	typeset _q _r _buff ; integer _q _r
	typeset -a _arr _barr

	(( _q = _n / _base ))
	(( _r = _n % _base ))
	_arr+=( ${_r} )
	until (( _q == 0 )); do
		_n=${_q}
		(( _q = _n / _base ))
		(( _r = _n % _base ))
		_arr+=( ${_r} )
	done
	_revarr _arr _barr
	_buff=${_barr[@]}
	echo ${_buff// /}
}

#	# Function _revarr(arr, barr) - reverse arr into barr
#
function _revarr {
	typeset _arr ; nameref _arr="$1"
	typeset _barr ; nameref _barr="$2"
	typeset _i ; integer _i

	for ((_i=${#_arr[*]}-1; _i>=0; _i--)); do
		_barr+=( ${_arr[_i]} )
	done
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

integer i sbi n=3 cnt=0

printf "First $PNUM Pernicious numbers:\n"
for ((n = cnt = 0; cnt < PNUM; n++)); do
	bi=$(_dec2bin ${n})		# $n as Binary
	sbi=${bi//0/}			# Strip zeros (i.e. count ones)
	_isprime ${#sbi}		# One count prime?
	(( $? )) && { printf "%4d " ${n} ; ((++cnt)) }
done

printf "\n\nPernicious numbers between %11,d and %11,d inclusive:\n" $MINN $MAXN
for ((i=MINN; i<=MAXN; i++)); do
	bi=$(_dec2bin ${i})
	sbi=${bi//0/}
	_isprime ${#sbi}
	(( $? )) && printf "%12,d " ${i}
done
echo
