Red [
	title: "Transpose / Zip"
	author: "hinjolicious"
]
; Transpose a matrix or list of lists, even a jagged one, i.e.: lists with
; different lengths.
; this essentially zipping related lists into a more contextual records.

; e.g.:
;	names: ["john" "jane" "bob"]
;	score: [80 60 90]
;	age: [30 25]

; IMPORTANT: before inputting to transpose func, be sure to form the matrix
;	correctly! [ names score age ] is not a matrix, but a list of three words!
;	do this instead: lists: reduce [ names score age ]
;	then input it as: transpose lists
;   the result would be: [ ["john" 80 30] ["jane" 60 25] ["bob" 90 0] ]

; NOTE: missing element are filled with relevant empty values, or according to refinements
	
#include %pipe-map.red
#include %fold.red

TRANSPOSE: context [

FILLER: function [list][ ; auto-filler helper function
	either empty? list [none] [
		e: list/1  case [
			integer? e	[0]
			float? e	[0.0]
			percent? e	[0%]
			money? e	[$0.00]
			string? e	[""]
			char? e		[#" "]
			logic? e	[false]
			date? e		[1-Jan-1900]
			time? e		[0:00:00]
			tuple? e	[0.0.0]
			image? e	[make image! [0x0]]
			bitset? e	[make bitset! ""]
			block? e	[[]]
			true		[none]
		]
	]
] ; /FILLER

TRANSPOSE: function [
	"Transposes/zip a matrix (list of lists) - Auto-fill shorter lists"
	matrix [block!] "Matrix as a block of blocks"
	/cyclic "Fill shorter list by repeating it cyclically (R-like)"
	/duplicate "Fill shorter list by duplicating each element"
	/fill value "Fill shorter list by a value"
	/fast "Assume a perfect rectangular matrix input. No validation!"
] [
	if empty? matrix [return copy []]
	
	if fast [ ; fast matrix transpose!
		return collect [repeat col length? matrix/1 [
			keep/only collect [foreach row matrix [keep/only row/:col]]
		]]
	]
	
	matrix ==> length? |> [fold _p :max] --> max-len
	
	matrix ==> [
		pad-list: copy _m
		needed: max-len - length? _m
		if needed > 0 [
			case [
				cyclic [ ; Repeat the shorter list (R-like behavior)
					cycle-length: length? _m
					repeat i needed [
						append/only pad-list pick _m (i - 1 % cycle-length) + 1
					]
				]
				duplicate [
					clear pad-list
					n: to-integer round/ceiling (max-len / (length? _m))
					repeat i (length? _m) [
						append/only/dup pad-list _m/:i n
					]
					if (length? pad-list) > max-len [
						;take/last pad-list
						clear at pad-list (max-len + 1)
					]
				]
				fill [insert/only/dup tail pad-list value needed]
				true [insert/only/dup tail pad-list (filler _m) needed]
			]
		]
		pad-list
	] --> padded-matrix
	
	; Transpose the matrix
	collect [repeat col max-len [
		keep/only collect [foreach row padded-matrix [
			keep/only row/:col
		]]
	]]
] ; /TRANSPOSE function
] ; /TRANSPOSE context

;== API ==
transpose: :transpose/transpose
zip: :transpose ; alias
; /API

;comment { ;== TEST ==

#include %mylib.red ; contain "demo" helper function

demo "Test 1: Regular matrix" [
m1: [ [a b c] [1 2 3] [x y z] ]
print mold transpose/fast m1
]

print "" demo "Test 2: Non-square matrix" [
m2: [ [A B C] [D E F] ]
print mold transpose/fast m2
]

print "" demo "Test 3: Jagged matrix (different row lengths)" [
m3: [ [1 2 3] [4 5] [6 7 8 9] ]
print mold transpose m3
]

print "" demo "Test 4: Single row" [
m4: [ [1 2 3 4 5] ]
print mold transpose m4
]

print "" demo "Test 5: Single column" [
m5: [ [1] [2] [3] [4] ]
print mold transpose m5
]

print "" demo "Test 6: Empty matrix" [
m6: []
print mold transpose m6
]

print "" demo "Cyclic fill test" [
m: [[a b][1 2 3 4]]
m |> [zip/cyclic _p] |> probe
]

demo "" [
m: [[a b][1 2 3 4 5]]
m |> [zip/cyclic _p] |> probe
]

print "" demo "Duplicate fill test" [
m: [[a b][1 2 3 4]]
m |> [zip/duplicate _p] |> probe
]

demo "" [
m: [[a b][1 2 3 4 5]]
m |> [zip/duplicate _p] |> probe
]

print "" demo "Auto fill test" [
m: [ [10 20] [1 2 3 4 5] [[a][b][c]] ]
m |> [zip _p] |> probe
]

demo "" [
m: [["A" "B"][1 2 3 4 5] [a b]]
m |> [zip _p] |> probe
]

;} ; /TEST
