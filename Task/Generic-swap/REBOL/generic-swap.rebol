REBOL [
	Title: "Generic Swap"
	Author: oofoe
	Date: 2009-12-06
	URL: http://rosettacode.org/wiki/Generic_swap
	Reference: [http://reboltutorial.com/blog/rebol-words/]
]

swap: func [
	"Swap contents of variables."
	a [word!] b [word!] /local x
][
	x: get a
	set a get b
	set b x
]

answer: 42  ship: "Heart of Gold"
swap 'answer 'ship ; Note quoted variables.
print rejoin ["The answer is " answer ", the ship is " ship "."]
