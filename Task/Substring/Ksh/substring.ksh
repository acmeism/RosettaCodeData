#!/bin/ksh

# Display a substring:
#	- starting from  n  characters in and of  m  length;
#	- starting from  n  characters in, up to the end of the string;
#	- whole string minus the last character;
#	- starting from a known character within the string and of  m  length;
#	- starting from a known substring within the string and of  m  length.

#	# Variables:
#

str='solve this task according to the task description,'
integer n=6 m=14
ch='v'
substr='acc'

#	# Functions:
#
#	# Function _length(str, start, length) - return substr from start,
#	# length chars long (length=-1 = end-of-str)
#
function _length {
	typeset _str ; _str="$1"
	typeset _st ; integer _st=$2
	typeset _ln ; integer _ln=$3

	(( _ln == -1 )) && 	echo "${_str:${_st}}"

	echo "${_str:${_st}:${_ln}}"
}

 ######
# main #
 ######
print -- "--String (Length: ${#str} chars):"
print "${str}\n"

print -- "--From char ${n} and ${m} chars in length:"
_length "${str}" ${n} ${m}
echo

print -- "--From char ${n} to the end:"
_length "${str}" ${n} -1

print -- "--Last character removed:"	# Strings in ksh are zero based
_length "${str}" 0 $(( ${#str}-1 ))
echo

print -- "-From char:'${ch}' and ${m} chars in length:"
foo=${str%${ch}*}
_length "${str}" ${#foo} ${m}
echo

print -- "-From substr:'${substr}' and ${m} chars in length:"
foo=${str%${substr}*}
_length "${str}" ${#foo} ${m}
echo
