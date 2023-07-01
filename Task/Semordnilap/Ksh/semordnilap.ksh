#!/bin/ksh

# Semordnilap

#	# Variables:
#
integer MIN_WORD_LEN=1 TRUE=1 FALSE=0
dict='/home/ostrande/prj/roscode/unixdict.txt'

integer i j=0 k=0
typeset -A word

#	# Functions:
#

#	# Function _flipit(string) - return flipped string
#
function _flipit {
	typeset _buf ; _buf="$1"
	typeset _tmp ; unset _tmp

	for (( _i=$(( ${#_buf}-1 )); _i>=0; _i-- )); do
		_tmp="${_tmp}${_buf:${_i}:1}"
	done

	echo "${_tmp}"
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
#	# Due to the large number of words in unixdist.txt subgroup by 1st letter and length
#	# only accept words containing alpha chars and > 1 chars
#
while read; do
	[[ $REPLY != *+(\W)* ]] && [[ $REPLY != *+(\d)* ]] &&	\
	  (( ${#REPLY} > MIN_WORD_LEN )) && word[${REPLY:0:1}][${#REPLY}]+=( $REPLY )
done < ${dict}

print Examples:
for fl in ${!word[*]}; do				# Over $fl first letter
	for len in ${!word[${fl}][*]}; do	# Over $len word length
		for ((i=0; i<${#word[${fl}][${len}][*]}; i++)); do
			Word=${word[${fl}][${len}][i]}		# dummy
			Try=$(_flipit ${Word})
			if [[ ${Try} != ${Word} ]]; then	# no palindromes
				unset words
				oldIFS="$IFS" ; IFS='|' ; words=${word[${Try:0:1}][${#Try}][*]} ; IFS="${oldIFS}"
				_isword "${Try}" words
				if (( $? )); then
					if [[ ${Try} != @(${uniq%\|*}) ]]; then
						((++j))
						(( ${#Word} >= 5 )) && (( k<=5 )) && print $((++k)). ${Word} ${Try}
						uniq+="${Try}|${Word}|"
					fi
				fi
			fi
		done
	done
done
echo ; print ${j} pairs found.
