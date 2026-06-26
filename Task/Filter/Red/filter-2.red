Red [
	title: "FILTER - Filter a list based on a condition"
	author: "hinjolicious"
	usage: {
		a: [1 2 3 4 5 6 7 8 9 10]
		print mold filter a [[x] x % 2 = 0]
		
		a: [[1 2] [3 6] [5 6] [7 14] [9 10]]
		print mold filter a [[x y] (x * 2) = y]
		print mold a || [[x y] (x * 2) = y]
	}
	collaborator: "Gemini AI"
]

; version 4
FILTER: function [list [series!] cond [block!]] [
    arg: cond/1
    filt: function arg next cond

    either (length? arg) = 1 [
        ; --- Fast Track: Single Argument ---
        collect [
            foreach elem list [
                if filt elem [keep/only elem]
            ]
        ]
    ][
        ; --- Fast Track: Multi-Argument Destructuring ---
        collect [
            foreach block list [
                ; 'apply' automatically unpacks the items inside 'block'
                ; into the individual positional arguments of 'filt'
                if apply :filt block [keep/only block]
            ]
        ]
    ]
]

||: make op! :FILTER

; test:

a: [1 2 3 4 5 6 7 8 9 10]
print mold filter a [[x] x % 2 = 0]

a: [[1 2] [3 6] [5 6] [7 14] [9 10]]
print mold filter a [[x y] (x * 2) = y]

print mold a || [[x y] (x * 2) = y]
