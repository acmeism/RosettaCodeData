#!/bin/sed -f
# (C) 2005,2014 by Mariusz Woloszyn :)
# https://en.wikipedia.org/wiki/Adder_(electronics)

##############################
# PURE SED BINARY FULL ADDER #
##############################


# Input two lines, sanitize input
N
s/ //g
/^[01	 ]\+\n[01	 ]\+$/! {
	i\
	ERROR: WRONG INPUT DATA
	d
	q
}
s/[ 	]//g

# Add place for Sum and Cary bit
s/$/\n\n0/

:LOOP
# Pick A,B and C bits and put that to hold
s/^\(.*\)\(.\)\n\(.*\)\(.\)\n\(.*\)\n\(.\)$/0\1\n0\3\n\5\n\6\2\4/
h

# Grab just A,B,C
s/^.*\n.*\n.*\n\(...\)$/\1/

# binary full adder module
# INPUT:  3bits (A,B,Carry in), for example 101
# OUTPUT: 2bits (Carry, Sum), for wxample   10
s/$/;000=00001=01010=01011=10100=01101=10110=10111=11/
s/^\(...\)[^;]*;[^;]*\1=\(..\).*/\2/

# Append the sum to hold
H

# Rewrite the output, append the sum bit to final sum
g
s/^\(.*\)\n\(.*\)\n\(.*\)\n...\n\(.\)\(.\)$/\1\n\2\n\5\3\n\4/

# Output result and exit if no more bits to process..
/^\([0]*\)\n\([0]*\)\n/ {
	s/^.*\n.*\n\(.*\)\n\(.\)/\2\1/
	s/^0\(.*\)/\1/
	q
}

b LOOP
