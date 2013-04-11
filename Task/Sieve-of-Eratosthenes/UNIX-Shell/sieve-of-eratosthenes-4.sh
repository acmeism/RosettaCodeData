# Fill $1 characters with $2.
fill () {
	# This pipeline would begin
	#   head -c $1 /dev/zero | ...
	# but some systems have no head -c. Use dd.
	dd if=/dev/zero bs=$1 count=1 2>/dev/null | tr '\0' $2
}

filter () {
	# Use sed to put an 'x' after each multiple of $1, remove
	# first 'x', and mark non-primes with '0'.
	sed -e s/$2/\&x/g -e s/x// -e s/.x/0/g | {
		if expr $1 '*' $1 '<' $3 > /dev/null; then
			filter `expr $1 + 1` .$2 $3
		else
			cat
		fi
	}
}

# Generate a sequence of 1s and 0s indicating primality.
oz () {
	fill $1 1 | sed s/1/0/ | filter 2 .. $1
}

# Echo prime numbers from 2 to $1.
prime () {
	# Escape backslash inside backquotes. sed sees one backslash.
	echo `oz $1 | sed 's/./&\\
/g' | grep -n 1 | sed s/:1//`
}

prime 1000
