#!/bin/ksh

# Find words with alternating vowels and consonants

#	# Variables:
#
dict='../unixdict.txt'

integer MINLENGTH=10
vowels='a|e|i|o|u'

#	# Functions:
#
#	# Function _isvowel(ch) - Return 1 if letter is a vowel
#
function _isvowel {
	typeset _ch ; typeset -l -L1 _ch="$1"

	[[ ${_ch} == @(${vowels}) ]] && return 1
	return 0
}
#	# Function _isalternating(str) - Return 1 if letter alternate vowel/const.
#
function _isalternating {
	typeset _str ; typeset -l _str="$1"
	typeset _i _rc ; integer _i _rc

	for ((_i=0; _i<${#_str}-1; _i++)); do
		_isvowel ${_str:${_i}:1} ; _rc=$?
		_isvowel ${_str:$((_i+1)):1}
		(( $? == _rc )) && return 0
	done
	return 1
}

 ######
# main #
 ######
while read; do
	(( ${#REPLY} < MINLENGTH )) && continue
	_isalternating "$REPLY"
	(( $? )) && print "$REPLY"
done < ${dict}
