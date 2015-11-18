#!/bin/bash

function countString(){
	input=$1
	cnt=0

	until [ "${input/$2/}" == "$input" ]; do
		input=${input/$2/}
		let cnt+=1
	done
	echo $cnt
}

countString "the three truths" "th"
countString "ababababab" "abab"
