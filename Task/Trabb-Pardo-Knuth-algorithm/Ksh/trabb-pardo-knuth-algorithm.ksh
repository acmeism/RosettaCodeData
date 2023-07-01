#!/bin/ksh

# Trabb Pardo–Knuth algorithm

#	# Variables:
#
integer NUM_ELE=11
typeset -F FUNC_LIMIT=400

#	# Functions:
#
#	# Function _input(_arr) - Ask for user input, build array
#
function _input {
	typeset _arr ; nameref _arr="$1"
	typeset _i ; integer _i

	clear ; print "Please input 11 numbers..."
	for ((_i=1 ; _i<=NUM_ELE ; _i++)); do
		read REPLY?"${_i}: "
		[[ $REPLY != {,1}(-)+(\d){,1}(.)*(\d) ]] && ((_i--)) && continue
		_arr+=( $REPLY )
	done
}

#	# Function _function() - Apply |x|^0.5 + 5x^3
#	#	note: >400 creates an overflow situation
#
function _function {
	typeset _x ; _x=$1

	(( _result = sqrt(abs(${_x})) + 5 * _x * _x * _x ))
	(( _result <= $FUNC_LIMIT )) && echo ${_result} && return 0
	return 1
}

 ######
# main #
 ######

typeset -a inputarr
_input inputarr
integer i
printf "%s\n\n" "Evaluating f(x) = |x|^0.5 + 5x^3 for the given inputs :"
for (( i=NUM_ELE-1; i>=0; i-- )); do
	result=$(_function ${inputarr[i]})
	if (( $? )); then
		printf "%s\n" "Overflow"
	else
		printf "%s\n" "${result}"
	fi
done
