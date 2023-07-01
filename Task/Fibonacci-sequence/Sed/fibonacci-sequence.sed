#!/bin/sed -f

# First we need to convert each number into the right number of ticks
# Start by marking digits
s/[0-9]/<&/g

# We have to do the digits manually.
s/0//g; s/1/|/g; s/2/||/g; s/3/|||/g; s/4/||||/g; s/5/|||||/g
s/6/||||||/g; s/7/|||||||/g; s/8/||||||||/g; s/9/|||||||||/g

# Multiply by ten for each digit from the front.
:tens
s/|</<||||||||||/g
t tens

# Done with digit markers
s/<//g

# Now the actual work.
:split
# Convert each stretch of n >= 2 ticks into two of n-1, with a mark between
s/|\(|\+\)/\1-\1/g
# Convert the previous mark and the first tick after it to a different mark
# giving us n-1+n-2 marks.
s/-|/+/g
# Jump back unless we're done.
t split
# Get rid of the pluses, we're done with them.
s/+//g

# Convert back to digits
:back
s/||||||||||/</g
s/<\([0-9]*\)$/<0\1/g
s/|||||||||/9/g;
s/|||||||||/9/g; s/||||||||/8/g; s/|||||||/7/g; s/||||||/6/g;
s/|||||/5/g; s/||||/4/g; s/|||/3/g; s/||/2/g; s/|/1/g;
s/</|/g
t back
s/^$/0/
