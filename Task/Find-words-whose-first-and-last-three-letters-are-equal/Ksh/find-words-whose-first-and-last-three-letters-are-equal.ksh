#!/bin/ksh

# Find list of words (> 5 chars) where 1st 3 and last 3 letters are the same

#	# Variables:
#
dict='../unixdict.txt'
integer MIN_LEN=5
integer MATCH_NO=3

 ######
# main #
 ######

 while read word; do
	(( ${#word} <= MIN_LEN )) && continue

	first=${word:0:${MATCH_NO}}
	last=${word:$((${#word}-MATCH_NO)):${#word}}

	[[ ${first} == ${last} ]] && print ${word}

 done < ${dict}
