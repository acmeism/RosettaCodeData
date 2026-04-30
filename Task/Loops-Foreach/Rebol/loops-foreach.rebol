REBOL [
	Title: "Loop/Foreach"
	URL: http://rosettacode.org/wiki/Loop/Foreach
]

names: [Sork Gun Blues Neds Thirst Fright Catur]

foreach name names [prin join name "day "]  print ""

; Rebol also has the 'forall' construct, which provides the rest of
; the list from the current position.

forall names [prin join names/1 "day "]  print ""
