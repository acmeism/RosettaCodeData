#!/bin/ksh

# Cyclops numbers (odd number of digits that has a zero in the center)
#	- first 50 cyclops numbers
#	- first 50 prime cyclops numbers
#	- first 50 blind prime cyclops numbers
#	- first 50 palindromic prime cyclops numbers

#	# Variables:
#
integer MAXN=50

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

#	# Function _iscyclops(n) - return 1 for cyclops number
#
function _iscyclops {
	typeset _n ; integer _n=$1

	(( ! ${#_n}&1 )) && return 0	# must have odd number of digits
	(( ${_n:$((${#_n}/2)):1} )) && return 0	# must have center zero
	[[ $(_blind ${_n}) == *0* ]] && return 0	# No other zeros

	return 1
}

#	# Function _blind(n) - return a "blinded" cyclops number
#
function _blind {
	typeset _n ; _n="$1"

	echo "${_n:0:$((${#_n}/2))}${_n:$((${#_n}/2+1)):$((${#_n}/2))}"
}

#	# Function _ispalindrome(n) - return 1 for palindromic number
#
function _ispalindrome {
	typeset _n ; _n="$1"
	typeset _flippedn

	_flippedn=$(_flipit ${_n:$((${#_n}/2+1)):$((${#_n}/2))})
	[[ ${_n:0:$((${#_n}/2))} != ${_flippedn} ]] && return 0
	return 1
}

#	# Function _flipit(string) - return flipped string
#
function _flipit {
	typeset _buf ; _buf="$1"
	typeset _tmp ; unset _tmp

	for (( _i=$(( ${#_buf}-1 )); _i>=0; _i-- )); do
		_tmp="${_tmp}${_buf:${_i}:1}"
	done

	echo "${_tmp}"
}
 ######
# main #
 ######

integer cy=prcy=blprcy=palprcy=0	# counters
typeset -a cyarr prcyarr blprcyarr palprcyarr

for i in {101..909} {11011..99099} {1110111..9990999}; do
	_iscyclops ${i} ; (( ! $? )) && continue
	(( ++cy <= MAXN )) && cyarr+=( ${i} )
	
	_isprime ${i} ; (( ! $? )) && continue
	(( ++prcy <= MAXN )) && prcyarr+=( ${i} )

	if (( blprcy < MAXN )); then
		_isprime $(_blind ${i})
		(( $? )) && { (( blprcy++ )) ; blprcyarr+=( ${i} ) }
	fi

	if (( palprcy < MAXN )); then
		_ispalindrome ${i}
		(( $? )) && { (( palprcy++ )) ; palprcyarr+=( ${i} ) }
	fi

	(( palprcy >= MAXN && blprcy >= MAXN && prcy >= MAXN && cy >= MAXN )) && break
done

print "First $MAXN cyclops numbers:"
print ${cyarr[@]}

print "\nFirst $MAXN prime cyclops numbers:"
print ${prcyarr[@]}

print "\nFirst $MAXN blind prime cyclops numbers:"
print ${blprcyarr[@]}

print "\nFirst $MAXN palindromic prime cyclops numbers:"
print ${palprcyarr[@]}
