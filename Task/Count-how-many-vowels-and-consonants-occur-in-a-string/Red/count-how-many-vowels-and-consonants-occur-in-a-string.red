Red [ "Count how many vowels and consonants occur in a string - hinjolicious" ]

fold: function [
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

demo: function [s b] [print ["^/==" s "==^/^/" mold/only b "^/>>"] do b]

demo "Count vowels and consonants from a string" [
s: "The quick brown fox jumps over the lazy dog"
freq: fold/init s [
	x: to-string _e
	cat: case [
		find "aiueo" x ['vowels]
		find "bcdfghjklmnpqrstvwxyz" x ['consonants]
		true ['others]
	]	
	_a/(cat): either none? _a/(cat) [put _a cat 1][_a/(cat) + 1]
	_a
] make map! [] ; initialized the accumulator with a map, so it will return as map!

?? freq
]
