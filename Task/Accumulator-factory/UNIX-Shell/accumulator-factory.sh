#!/bin/sh
accumulator() {
	# Define a global function named $1
	# with a global variable named ${1}_sum.
	eval "${1}_sum=\$2"
	eval "$1() {
		${1}_sum=\$(echo \"(\$${1}_sum) + (\$2)\" | bc)
		eval \"\$1=\\\$${1}_sum\"  # Provide the current sum.
	}"
}

accumulator x 1
x r 5
accumulator y 3
x r 2.3
echo $r
y r -3000
echo $r
