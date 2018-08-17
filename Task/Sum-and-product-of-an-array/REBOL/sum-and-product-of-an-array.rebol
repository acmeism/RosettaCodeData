REBOL [
    Title: "Sum and Product"
    URL: http://rosettacode.org/wiki/Sum_and_product_of_array
]

; Simple:

sum: func [a [block!] /local x] [x: 0  forall a [x: x + a/1]  x]

product: func [a [block!] /local x] [x: 1  forall a [x: x * a/1]  x]

; Way too fancy:

redux: func [
	"Applies an operation across an array to produce a reduced value."
	a [block!] "Array to operate on."
	op [word!] "Operation to perform."
	/init x    "Initial value (default 0)."
][if not init [x: 0]  forall a [x: do compose [x (op) (a/1)]]  x]

rsum: func [a [block!]][redux a '+]

rproduct: func [a [block!]][redux/init a '* 1]

; Tests:

assert: func [code][print [either do code ["  ok"]["FAIL"]  mold code]]

print "Simple dedicated functions:"
assert [55      = sum [1 2 3 4 5 6 7 8 9 10]]
assert [3628800 = product [1 2 3 4 5 6 7 8 9 10]]

print [crlf "Fancy reducing function:"]
assert [55      = rsum [1 2 3 4 5 6 7 8 9 10]]
assert [3628800 = rproduct [1 2 3 4 5 6 7 8 9 10]]
