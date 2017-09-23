#!/bin/sed -rf
# Input: <number 0..25>\ntext to encode

/^[0-9]+$/ {
	# validate a number and translate it to analog form
	s/$/;9876543210dddddddddd/
	s/([0-9]);.*\1.{10}(.?)/\2/
	s/2/11/
	s/1/dddddddddd/g
	/[3-9]|d{25}d+/ {
	s/.*/Error: Key must be <= 25/
	q
	}
	# append from-table
	s/$/\nabcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/
	# .. and to-table
	s/$/abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ/
	# rotate to-table, lower and uppercase independently, removing one `d' at a time
	: rotate
	s/^d(.*\n[^Z]+Z)(.)(.{25})(.)(.{25})/\1\3\2\5\4/
	t rotate
	s/\n//
	h
	d
}

# use \n to mark character to convert
s/^/\n/
# append conversion table to pattern space
G
: loop
	# look up converted character and place it instead of old one
	s/\n(.)(.*\n.*\1.{51}(.))/\n\3\2/
	# advance \n even if prev. command fails, thus skip non-alphabetical characters
	/\n\n/! s/\n([^\n])/\1\n/
t loop
s/\n\n.*//
