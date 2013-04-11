REBOL [
	Title: "Loop/Foreach"
	Author: oofoe
	Date: 2009-12-19
	URL: http://rosettacode.org/wiki/Loop/Foreach
]

x: [Sork Gun Blues Neds Thirst Fright Catur]

foreach i x [prin rejoin [i "day "]]  print ""

; REBOL also has the 'forall' construct, which provides the rest of
; the list from the current position.

forall x [prin rejoin [x/1 "day "]]  print ""
