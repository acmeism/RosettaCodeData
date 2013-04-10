/^[ \t]*-?[0-9]+[ \t]+-?[0-9]+[ \t]*$/ {
	print "add:", $1 + $2
	print "sub:", $1 - $2
	print "mul:", $1 * $2
	print "div:", int($1 / $2) # truncates toward zero
	print "mod:", $1 % $2      # same sign as first operand
	print "exp:", $1 ^ $2
	exit }
