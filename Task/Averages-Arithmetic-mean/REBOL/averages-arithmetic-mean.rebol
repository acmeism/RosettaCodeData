rebol [
    Title: "Arithmetic Mean (Average)"
    Author: oofoe
    Date: 2009-12-11
    URL: http://rosettacode.org/wiki/Average/Arithmetic_mean
]

average: func [v /local sum][
	if empty? v [return 0]

	sum: 0
	forall v [sum: sum + v/1]
	sum / length? v
]

; Note precision loss as spread increased.

print [mold x: [] "->" average x]
print [mold x: [3 1 4 1 5 9] "->" average x]
print [mold x: [1000 3 1 4 1 5 9 -1000] "->" average x]
print [mold x: [1e20 3 1 4 1 5 9 -1e20] "->" average x]
