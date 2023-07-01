#!/bin/sed -nrf
# Format: <master-pattern>\n<line1>\n<line1-as-pattern>\n<line2>\n<line2-as-pattern>...
# After reading whole file <master-pattern> contains max number of fields of max width each.

# If no $ at start or end of a line -- add them
/^\$/! s/^/$/
/\$$/! s/$/$/

# First line saved as three lines in hold space:
# <line1-as-pattern>\n<line1>\n<line1-as-pattern>
1{
 h
 s/[^$]/ /g
 H
 G
 x
 # Restart -- go to next line
 b
}

# For lines 2,3,...
H
# Current line -> pattern
# (each character replaced by constant symbol (e.g. space) so that we can count them)
s/[^$]/ /g
H
G
# Add two markers
s/\$/1$/
s/(\n[^$]*)\$/\12$/

# Compare patterns
:cmp
	s/(1\$([^$\n]*)([^$\n]*)[^2]*2\$\2)/\1\3/
	/1\$\n/ bout
	# Advance markers
	s/1(\$[^12$\n]*)/\11/
	s/2(\$[^12$\n]*)/\12/
	# Add one more field
	/^[^2]*2\$\n/{ s/^([^2]*)2\$\n/\12$$\n/; }
bcmp
:out
# Remove first line
s/[^\n]*\n//
# Remove 2$-marker
s/2\$/$/
x

${
# We are on the last line -- start printing
	x;
	# Add a line for aligned string
	s/^/\n/
	:nextline
	# Add marker again (only one this time)
	s/\$/1$/
	:align
		# 1. look up missing spaces,
		# 2. put first word of 2nd line before first newline adding missing spaces
		# 3. cut first word of 2nd and 3rd lines.
		# Replace \5\3 by \3\5 for RIGHT ALIGNMENT
		s/(\n[^\n]*)1\$([^$\n]*)([^$\n]*)\$([^\n]*\n)\$([^$\n]*)([^\n]*\n)\$\2\$/\5\3 \1$\2\31$\4\6$/
	talign
	# We ate 2nd and 3rd lines completely, except newlines -- remove them
	s/\$\n\$\n\$\n/$\n/
	# Print the first line in pattern space
	P
	# ... and remove it
	s/^[^\n]*//
	# Remove marker
	s/1\$/$/
	# If no more lines -- exit
	/\$\n\$$/q
	bnextline
}
