REBOL [
    Title: "Loop Plus Half"
    URL: http://rosettacode.org/wiki/Loop/n_plus_one_half
]

repeat i 10 [
	prin i
	if 10 = i [break]
	prin ", "
]
print ""
