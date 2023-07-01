#!/bin/ksh

# Determine if a string is collapsible (repeated letters)

#	# Variables:
#
typeset -a strings
strings[0]=""
strings[1]='"If I were two-faced, would I be wearing this one?" --- Abraham Lincoln'
strings[2]="..1111111111111111111111111111111111111111111111111111111111111117777888"
strings[3]="I never give 'em hell, I just tell the truth, and they think it's hell."
strings[4]="                                                    --- Harry S Truman"

typeset -a Guillemet=( "«««" "»»»" )

#	# Functions:
#
#	# Function _collapse(str) - return colapsed version of str
#
function _collapse {
	typeset _str ; _str="$1"
	typeset _i _buff ; integer _i

	for ((_i=1; _i<${#_str}; _i++)); do
		if [[ "${_str:$((_i-1)):1}" == "${_str:${_i}:1}" ]]; then
			continue
		else
			_buff+=${_str:$((_i-1)):1}
		fi
	done
	[[ "${_str:$((_i-1)):1}" != "${_str:${_i}:1}" ]] && _buff+=${_str:$((_i-1)):1}
	echo "${_buff}"
}

 ######
# main #
 ######
for ((i=0; i<${#strings[*]}; i++)); do
	str=$(_collapse "${strings[i]}")
	print ${#strings[i]} "${Guillemet[0]}${strings[i]}${Guillemet[1]}"
	print ${#str} "${Guillemet[0]}${str}${Guillemet[1]}\n"
done
