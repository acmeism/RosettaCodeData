Red [ title: "Fold / Reduce" author: "hinjolicious" ]

; Reduce a list to a value using a function or a code block
; A code block can use placeholders:
;	_a	-> accumulator
;	_e	-> list elements

FOLD: function [
	"Reduces (folds) a series to a single value using a function or code block."
	list [series!]
	action [block! any-function!]
	/init acc "Supply an initial accumulator value"
][
	unless init [
		acc: first list
		list: next list
	]
	either any-function? :action [
		foreach e list [acc: action acc e]
	][
		f: function [_a _e] action
		foreach e list [acc: f acc e]
	]
	acc
]

;comment {

; == Testing FOLD ==

#include %mylib.red
; mylib.red contain "demo", a simple helper function to display the code and execute it

demo "The simplest usage of fold:" [
x: [1 2 3 4 5]
print fold x :add ; fold x using "add" function and print the result
]

; using fold together with the pipelining and mapping functional style code
#include %pipe-map.red

print ""
demo "Using fold to sum a list" [
x |> [fold _p :add] |> probe ; the same as above with pipe operator (_p is the pipe element)
x |> [fold _p [_a + _e]] |> probe ; using fold with "code block" (_a is accumulator, _e is element)
]

; more advanced test

print ""
demo "Using fold to create frequency map from a list" [
["apple" "banana" "apple" "cherry" "apple" "cherry" "orange"]
	|> [
		fold/init _p [
			_a/(_e): either none? _a/(_e) [put _a _e 1] [_a/(_e) + 1]
			_a
		] make map! [] ; initialized the accumulator with an empty map, so it will return a map!
	] --> z ; assign the result to z
?? z ; print it
]

; output should be like this:
;z: #[
;    "apple" 3
;    "banana" 1
;    "cherry" 2
;    "orange" 1
;]

print ""
demo "Count vowels and consonants from a string" [
"The quick brown fox jumps over the lazy dog"
	|> [
		fold/init _p [
			cat: either find "aiueo" to-string _e ['vowel]['consonants]
			_a/(cat): either none? _a/(cat) [put _a cat 1][_a/(cat) + 1]
			_a
		] make map! [] ; initialized the accumulator with a map, so it will return as map!
	] |> probe
]

;}
