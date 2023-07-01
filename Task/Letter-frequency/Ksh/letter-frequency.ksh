#!/bin/ksh

# Count the occurrences of each character

 ######
# main #
 ######

typeset -iA freqCnt
while read; do
	for ((i=0; i<${#REPLY}; i++)); do
		(( freqCnt[${REPLY:i:1}]++ ))
	done
done < $0		## Count chars of this code file

for ch in "${!freqCnt[@]}"; do
	[[ ${ch} == ?(\S) ]] && print -- "${ch}  ${freqCnt[${ch}]}"
done
