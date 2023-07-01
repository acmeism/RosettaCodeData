REBOL [
	Title: "Function Argument"
	URL: http://rosettacode.org/wiki/Function_as_an_Argument
]

map: func [
	"Apply function to contents of list, return new list."
	f [function!] "Function to apply to list."
	data [block! list!] "List to transform."
	/local result i
][
	result: copy []  repeat i data [append result f i]  result]

square: func [
	"Calculate x^2."
	x [number!]
][x * x]

cube: func [
	"Calculate x^3."
	x [number!]
][x * x * x]

; Testing:

x: [1 2 3 4 5]
print ["Data:   "  mold x]
print ["Squared:"  mold map :square x]
print ["Cubed:  "  mold map :cube x]
print ["Unnamed:"  mold map func [i][i * 2 + 1] x]
