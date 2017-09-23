#!/bin/sed -f

# Add a marker in front of each digit, for tracking tens, hundreds, etc.
s/[0-9]/<&/g
# Convert numbers to, in essence, tally marks
s/0//g; s/1/|/g; s/2/||/g; s/3/|||/g; s/4/||||/g; s/5/|||||/g
s/6/||||||/g; s/7/|||||||/g; s/8/||||||||/g; s/9/|||||||||/g

# Multiply by ten for each digit from the back they were.
:tens
s/|</<||||||||||/g
t tens

# We don't want the digit markers any more
s/<//g

# Negative minus negative is the negation of their absolute values.
s/^-\(|*\) *-/-\1/
# Negative plus positive equals positive plus negative, and we want the negative at the back.
s/^-\(|*\) \+\(|*\)$/\2-\1/
# Get rid of any space between the numbers
s/ //g

# A tally on each side can be canceled.
:minus
s/|-|/-/
t minus
s/-$//

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
