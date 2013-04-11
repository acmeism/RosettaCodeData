REBOL [
	Title: "Yuletide Holiday"
	Author: oofoe
	Date: 2009-12-07
	URL: http://rosettacode.org/wiki/Yuletide_Holiday
]

for y 2008 2121 1 [
	d: to-date reduce [y 12 25]
	if 7 = d/weekday [prin [y ""]]
]
