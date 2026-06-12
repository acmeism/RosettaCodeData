#!/bin/ksh

# Count how many vowels and consonants occur in a string

#	# Variables:
#
string1="Now is the time for all good men to come to the aid of their country."
string=${1:-${string1}}		# Allow command line input

consonant="b|c|d|f|g|h|j|k|l|m|n|p|q|r|s|t|v|w|x|y|z"
vowel="a|e|i|o|u"

integer i rc
typeset -ia lettercnt uniquecnt
typeset -a letlist

#	# Functions:
#
#	# Function _vorc(ch) - Return 0 if consonant; 1 if vowel; 99 else
#
function _vorc {
	typeset _ch ; typeset -l _char="$1"

	[[ "${_char}" == @(${consonant}) ]] && return 0
	[[ "${_char}" == @(${vowel}) ]] && return 1
	return 99
}

#	# Function _uniq(char, type, list, arr) - increment arr[] if chart not in list[]
#
function _uniq {
	typeset _char ; _char="$1"
	typeset _type ; integer _type=$2
	typeset _list ; nameref _list="$3"
	typeset _arr  ; nameref _arr="$4"

	if [[ "${_char}" != @(${_list[_type]% *}) ]]; then
		_list[_type]+="${_char}|"		# Add letter to the proper list
		(( _arr[_type]++ ))				# Increment uniq counter
	fi
}

 ######
# main #
 ######

echo "${string}" | while read ; do
	for ((i=0; i<${#REPLY}; i++)); do
		char="${REPLY:${i}:1}"
		_vorc "${char}" ; rc=$?
		(( rc != 99 )) && (( lettercnt[rc]++ )) && _uniq "${char}" ${rc} letlist uniquecnt
	done
done

printf "\n%s\n\n" "${string}"
printf "Consonants: %3d  (Unique: %2d)\n" "${lettercnt[0]}" "${uniquecnt[0]}"
printf "   Vowlels: %3d  (Unique: %2d)\n" "${lettercnt[1]}" "${uniquecnt[1]}"
