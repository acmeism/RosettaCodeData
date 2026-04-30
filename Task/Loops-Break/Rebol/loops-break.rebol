REBOL [
	Title: "Loop/Break"
	URL: http://rosettacode.org/wiki/Loop/Break
]

random/seed 1 ; Make repeatable.
; random/seed now ; Uncomment for 'true' randomness.

r20: does [(random 20) - 1]

forever [
	prin x: r20
	if 10 = x [break]
	print rejoin [" " r20]
]
print ""
