#!/bin/ksh

# Tokenize a string

#	# Variables:
#
string="Hello,How,Are,You,Today"
inputdelim=\,		# a comma
outputdelim=\.		# a period

#	# Functions:
#
#	# Function _tokenize(str, indelim, outdelim)
#
function _tokenize {
	typeset _str ; _str="$1"
	typeset _ind ; _ind="$2"
	typeset _outd ; _outd="$3"
	
	while [[ ${_str} != ${_str/${_ind}/${_outd}} ]]; do
		_str=${_str/${_ind}/${_outd}}
	done

	echo "${_str}"
}

 ######
# main #
 ######

 _tokenize "${string}" "${inputdelim}" "${outputdelim}"
