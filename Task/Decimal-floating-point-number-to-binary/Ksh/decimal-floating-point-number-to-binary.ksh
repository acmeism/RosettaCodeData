#!/bin/ksh

# Decimal floating point number to binary

#	# Variables:
#

#	# Functions:
#

#	# Function _fpdec2bin(n.d) - return binary of floating point decimal n.d
#
function _fpdec2bin {
	typeset _fp ; _fp=$1
	typeset _base ; integer _base=2
	typeset _n _q _r _whole _fract ; integer _n _q _r
	typeset _p _d ; float _p _d=.0
	typeset -a _arr _barr

	_n=${_fp%\.*}
	[[ ${_fp} == +(\d)\.*(\d) ]] && _d=${_fp#*${_n}}

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
	_whole=${_barr[@]} ; _whole=${_whole// /}

	(( _p = _d * _base ))
	unset _q ; _q=${_p%\.*}
	_fract="${_q}" ; float _q
	(( _d = _p - _q ))
	until (( ${_d} == 0.0 )); do
		(( _p = _d * _base ))
		unset _q ; _q=${_p%\.*}
		_fract+=${_q} ; float _q
		(( _d = _p - _q ))
	done

	echo "${_whole}.${_fract}"
}

#	# Function _fpbin2dec(b) - return floating point decimal for binary b
#
function _fpbin2dec {
	typeset _b ; _b=$1
	[[ ${_b} != *(0|1)*(\.)*(0|1) ]] && return 1

	typeset _m ; _m=${_b%\.*}	# Before the .
	typeset _d ; _d=${_b#*\.}	# After the .
	typeset _i _p _base ; typeset -si _i _p=0 _base=2
	typeset _msum ; typeset -si _msum=0
	typeset _psum ; float _psum=0

	for ((_i=${#_m}-1; _i>=0; _i--)); do
		(( ${_m:_i:1} )) && (( _msum+=(_base**_p) ))
		(( _p++ ))
	done

	_p=1
	for ((_i=0; _i<${#_d}; _i++)); do
		(( ${_d:_i:1} )) && (( _psum+=(1.0 / (_base**_p)) ))
		(( _p++ ))
	done
	echo "${_msum}.${_psum#*0\.}"
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

 ######
# main #
 ######

print "Floating point decimal to Binary conversion:"
print "23.34375 => $(_fpdec2bin 23.34375)"
print "11.90625 => $(_fpdec2bin 11.90625)"

print "\nFloating point binary to decimal conversion:"
print "10111.01011 => $(_fpbin2dec 10111.01011)"
print "1011.11101  => $(_fpbin2dec 1011.11101)"
