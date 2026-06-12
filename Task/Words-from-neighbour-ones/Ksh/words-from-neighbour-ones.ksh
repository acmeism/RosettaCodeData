#!/bin/ksh

# Words from neighbour ones

#	# Variables:
#
dict='/home/ostrande/prj/roscode/unixdict.txt'
integer MIN_WORD_LEN=9 TRUE=1 FALSE=0

typeset -a word newword
integer i j=0

#	# Functions:
#
#	# Function _buildword(arr) - build MIN_WORD_LEN word from arr eles
#
function _buildword {
	typeset _arr ; nameref _arr="$1"
	typeset _indx ; integer _indx=$2
	typeset _i _str ; integer _i

	for ((_i=0; _i<MIN_WORD_LEN; _i++)); do
		_str+=${_arr[$((_indx+_i))]:${_i}:1}
	done
	echo "${_str}"
}

#	# Function _isword(word, wordlist) - return 1 if word in wordlist
#
function _isword {
	typeset _word ; _word="$1"
	typeset _wordlist ; nameref _wordlist="$2"

	[[ ${_word} == @(${_wordlist}) ]] && return $TRUE
	return $FALSE
}

 ######
# main #
 ######

while read; do
	(( ${#REPLY} >= MIN_WORD_LEN )) && word+=( $REPLY )
done < ${dict}
oldIFS="$IFS" ; IFS='|' ; words=${word[*]} ; IFS="${oldIFS}"

for ((i=0; i<${#word[*]}; i++)); do
	candidate=$(_buildword word ${i})
	_isword "${candidate}" words
	if (( $? )); then
		if [[ ${candidate} != @(${uniq%\|*}) ]]; then
			print $((++j)) ${candidate}
			uniq+="${candidate}|"
		fi
	fi
done
