#!/bin/ksh

# Find the corresponding UPC decimal representation of each, rejecting the error

#	# Variables:
#
UPC_data_file="../upc.data"
END_SEQ='# #'		# Start and End sequence
MID_SEQ=' # # '		# Middle sequence
typeset -a CHK_ARR=( 3 1 3 1 3 1 3 1 3 1 3 1 )
integer bpd=7		# Number of bits per digit
integer numdig=6	# Number of digits per "side"
typeset -a umess=( '' 'Upside down')
typeset -a udig=( 0001101 0011001 0010011 0111101 0100011 0110001 0101111 0111011 0110111 0001011 )

#	# Functions:
#

#	# Function _validate(array) - verify result with CHK_ARR
#
function _validate {
	typeset _arr ; nameref _arr="$1"
	typeset _ifs ; _ifs="$2"
	typeset _dp _singlearr _oldIFS

	_oldIFS=$IFS ; IFS=${_ifs}
	typeset -ia _singlearr=( ${_arr[@]} )
	integer _dp=$(_dotproduct _singlearr CHK_ARR)
	IFS=${_oldIFS}

	return $(( _dp % 10 ))
}

#	# Function _dotproduct(arr1, arr2) - return dot product
#
function _dotproduct {
	typeset _arr1 ; nameref _arr1="$1"
	typeset _arr2 ; nameref _arr2="$2"
	typeset _i _dp ; integer _i _dp

	for (( _i=0; _i<${#_arr1[*]}; _i++ )); do
		(( _dp += ( _arr1[_i] * _arr2[_i] ) ))
	done
	echo ${_dp}
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

#	# Function _bitget(string, side) - return bitless string & bit
#
function _bitget {
	typeset _buff ; _buff="$1"
	typeset _side ; integer _side=$2
	typeset _ubit _bit

	_ubit=${_buff:0:1}
	[[ ${_ubit} == \# ]] && _bit=1 || _bit=0
	(( _side )) && (( _bit = ! _bit ))

	echo ${_buff#*${_ubit}}
	return ${_bit}
}

#	# Function _decode(upc_arr, digit_arr)
#
function _decode {
	typeset _uarr ; nameref _uarr="$1"	# UPC code array
	typeset _darr ; nameref _darr="$2"	# Decimal array

	typeset _s _d _b _bit _digit _uarrcopy ; integer _s _d _b _bit
	typeset -a _uarrcopy=( ${_uarr[@]} )

	for (( _s=0; _s<${#_uarr[*]}; _s++ )); do	# each "side"
		for (( _d=0; _d<numdig; _d++ ))  ; do	# each "digit"
			for (( _b=0; _b<bpd; _b++ )) ; do	# each "bit"
				_uarr[_s]=$(_bitget ${_uarr[_s]} ${_s}) ; _bit=$?
				_digit="${_digit}${_bit}"
			done

			_darr[_s]="${_darr[_s]} $(_todec ${_digit})"
			if (( $? )); then		# May be upside-down
				typeset -a _uarr=( ${_uarrcopy[@]} )	# Replace
				return 1
			fi
			unset _digit
		done
	done
}

#	# Function _todec(digit) - Return numeric digit from upc code
#
function _todec {
	typeset _bdig ; _bdig="$1"
	typeset _i ; integer _i

	for (( _i=0; _i<${#udig[*]}; _i++ )); do
		[[ ${_bdig} == ${udig[_i]} ]] && echo ${_i} && return 0
	done
	return 1
}

#	# Function _parseUPC(str, arr) - parse UPS string into 2 ele array
#
function _parseUPC {
	typeset _buf ; typeset _buf="$1"
	typeset _arr ; nameref _arr="$2"
	typeset _pre _mid

	_pre="${_buf%%${END_SEQ}*}"
	_buf="${_buf#*${_pre}}"				# Strip preamble
	_buf="${_buf#*${END_SEQ}}"			# Strip $SEQ

	_arr[0]="${_buf:0:$((bpd * numdig))}"	# Get the left hand digits
	_buf="${_buf#*${_arr[0]}}"				# Strip left side digits

	_mid="${_buf:0:5}"					# Check the middle SEQ
	_buf="${_buf#*${MID_SEQ}}"			# Strip $SEQ

	_arr[1]="${_buf:0:$((bpd * numdig))}"	# Get the right hand digits
	_buf="${_buf#*${_arr[1]}}"				# Strip right side digits

	_end="${_buf:0:3}"					# Check the end SEQ
	_buf="${_buf#*${END_SEQ}}"			# Strip $SEQ
}

 ######
# main #
 ######

oldIFS="$IFS" ; IFS=''
while read; do
	[[ "$REPLY" == \;* ]] && continue

	unset side_arr ; typeset -a side_arr	# [0]=left [1]=right
	_parseUPC "$REPLY" side_arr

	unset digit_arr ; typeset -a digit_arr	# [0]=left [1]=right
	_decode side_arr digit_arr ; integer uflg=$?
	if (( uflg )); then			# Flip sides and reverse UPC_code
		unset digit_arr ; typeset -a digit_arr	# [0]=left [1]=right
		buff="$(_flipit "${side_arr[0]}")"
		side_arr[0]="$(_flipit "${side_arr[1]}")"
		side_arr[1]="${buff}"
		_decode side_arr digit_arr ; integer vflg=$?
	fi

	(( ! vflg )) && _validate digit_arr "${oldIFS}" ; integer vflg=$?
	if (( vflg )); then
		print "INVALID DIGIT(S)"
		unset vflg
	else
		print "${digit_arr[*]} ${umess[uflg]}"
		unset uflg
	fi

done < ${UPC_data_file}
