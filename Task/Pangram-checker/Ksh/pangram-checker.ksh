#!/bin/ksh

# Pangram checker

#	# Variables:
#
alphabet='abcdefghijklmnopqrstuvwxyz'

typeset -a strs
strs+=( 'Mr. Jock, TV quiz PhD., bags few lynx.' )
strs+=( 'A very mad quack might jinx zippy fowls.' )

#	# Functions:
#

#	# Function _ispangram(str) - return 0 if str is a pangram
#
function _ispangram {
	typeset _str ; typeset -l _str="$1"
	typeset _buff ; _buff="${alphabet}"
	typeset _i ; typeset -si _i

	for ((_i=0; _i<${#_str} && ${#_buff}>0; _i++)); do
		_buff=${_buff/${_str:${_i}:1}/}
	done
	return ${#_buff}
}

 ######
# main #
 ######

typeset -si i
for ((i=0; i<${#strs[*]}; i++)); do
	_ispangram "${strs[i]}"
	if (( ! $? )); then
		print "${strs[i]}   <<< IS A PANGRAM."
	else
		print "${strs[i]} <<< Is not a pangram."
	fi
done
