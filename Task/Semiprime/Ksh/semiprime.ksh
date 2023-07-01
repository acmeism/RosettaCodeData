#!/bin/ksh

# Semiprime - As translated from C

#	# Variables:
#

#	# Functions:
#
# Function _issemiprime(p2) - return 1 if p2 semiprime, 0 if not
#
function _issemiprime {
	typeset _p2 ; integer _p2=$1
	typeset _p _f ; integer _p _f=0

	for ((_p=2; (_f<2 && _p*_p<=_p2); _p++)); do
		while (( _p2 % _p == 0 )); do
			(( _p2 /= _p ))
			(( _f++ ))
		done
	done

	return $(( _f + (_p2 > 1) == 2 ))
}

 ######
# main #
 ######

integer i
for ((i=2; i<100; i++)); do
	_issemiprime ${i}
	(( $? )) && printf " %d" ${i}
done
echo
