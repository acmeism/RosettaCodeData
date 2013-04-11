REBOL [
    Title: "Maximum Value"
    Date: 2009-12-15
    Author: oofoe
    URL: http://rosettacode.org/wiki/Maximum_Value
]

max: func [
	"Find maximum value in a list."
	values [series!] "List of values."
] [
	first maximum-of values
]

print ["Max of"  mold d: [5 4 3 2 1]  "is"  max d]
print ["Max of"  mold d: [-5 -4 -3 -2 -1]  "is"  max d]
