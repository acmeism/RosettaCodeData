#!/bin/ksh

# rot-13 function

#	# Variables:
#
integer ROT_NUM=13			# Generalize to any ROT

string1="A2p"				# Default "test"
string=${1:-${string1}}		# Allow command line input

typeset -a lcalph=( a b c d e f g h i j k l m n o p q r s t u v w x y z )
typeset -a ucalph=( A B C D E F G H I J K L M N O P Q R S T U V W X Y Z )

#	# Functions:
#
#	# Function _rotN(char) - return the "rotated" N letter to char
# Needs: $ROT_NUM defined
#
function _rotN {
	typeset _char ; _char="$1"
	typeset _casechk _alpha _oldIFS _buff _indx

	[[ ${_char} != @(\w) || ${_char} == @(\d) ]] && echo "${_char}" && return	# Non-alpha

	typeset -l _casechk="${_char}"
	[[ ${_casechk} == "${_char}" ]] && nameref _aplha=lcalph || nameref _aplha=ucalph

	_oldIFS="$IFS" ; IFS='' ; _buff="${_aplha[*]}" ; IFS="${oldIFS}"
	_indx=${_buff%${_char}*}
	echo ${_aplha[$(( (${#_indx}+ROT_NUM) % (ROT_NUM * 2) ))]}
	typeset +n _aplha
	return
}

 ######
# main #
 ######

for ((i=0; i<${#string}; i++)); do
	buff+=$(_rotN "${string:${i}:1}")
done

print "${string}"
print "${buff}"
