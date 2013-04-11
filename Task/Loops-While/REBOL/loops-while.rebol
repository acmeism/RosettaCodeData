REBOL [
	Title: "Loop/While"
	Author: oofoe
	Date: 2009-12-19
	URL: http://rosettacode.org/wiki/Loop/While
]

value: 1024
while [value > 0][
	print value
	value: to-integer value / 2
]
