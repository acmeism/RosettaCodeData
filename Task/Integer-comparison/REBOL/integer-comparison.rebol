REBOL [
	Title: "Comparing Two Integers"
	URL: http://rosettacode.org/wiki/Comparing_two_integers
]

a: ask "First integer? "  b: ask "Second integer? "

relation: [
	a < b "less than"
	a = b "equal to"
	a > b "greater than"
]
print [a "is"  case relation  b]
