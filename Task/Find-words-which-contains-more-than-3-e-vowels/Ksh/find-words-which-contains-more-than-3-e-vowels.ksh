#!/bin/ksh

# Find words which contains more than 3 e vowels and only e vowels

#	# Variables:
#
badvowels='a|i|o|u'
typeset -si MINE=4

dictionary='../unixdict.txt'

#	# Functions:
#

#	# Function _countch(str, ch) return cpount of ch in  str
#
function _countch {
	typeset _str ; typeset -l _str="$1"
	typeset _ch ; typeset -lL1 _ch="$2"
	typeset _i _cnt ; typeset -si _i _cnt=0

	for ((_i=0; _i<${#_str}; _i++)); do
		[[ ${_str:_i:1} == ${_ch} ]] && (( _cnt++ ))
	done
	echo ${_cnt}
}

 ######
# main #
 ######

while read; do
	[[ $REPLY == *+(${badvowels})* ]] && continue
	(( $(_countch "$REPLY" "e") >= MINE )) && print $REPLY
done < ${dictionary}
