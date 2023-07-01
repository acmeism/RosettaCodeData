REBOL [
	Title: "Loop/While"
	URL: http://rosettacode.org/wiki/Loop/Do_While
]

; REBOL doesn't have a specific 'do/while' construct, but 'until' can
; be used to provide the same effect.

value: 0
until [
	value: value + 1
	print value

	0 = mod value 6
]
