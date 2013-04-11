REBOL [
    Title: "Array Callback"
    Date: 2010-01-04
    Author: oofoe
    URL: http://rosettacode.org/wiki/Apply_a_callback_to_an_Array
]

map: func [
	"Apply a function across an array."
	f [native! function!] "Function to apply to each element of array."
	a [block!] "Array to process."
	/local x
][x: copy []  forall a [append x do [f a/1]]  x]

square: func [x][x * x]

; Tests:

assert: func [code][print [either do code ["  ok"]["FAIL"]  mold code]]

print "Simple loop, modify in place:"
assert [[1 100 81] = (a: [1 10 9]  forall a [a/1: square a/1]  a)]

print [crlf "Functional style with 'map':"]
assert [[4 16 36] = map :square [2 4 6]]

print [crlf "Applying native function with 'map':"]
assert [[2 4 6] = map :square-root [4 16 36]]
