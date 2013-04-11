REBOL [
    Title: "Loop Plus Half"
    Date: 2009-12-16
    Author: oofoe
    URL: http://rosettacode.org/wiki/Loop/n_plus_one_half
]

repeat i 10 [
	prin i
	if 10 = i [break]
	prin ", "
]
print ""
