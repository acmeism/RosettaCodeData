Red [
	title: "List Comprehensions"
	author: "hinjolicoius"
	resources: {
		lc function by maximvl (originaly by steveGit).
		Link: https://gist.github.com/maximvl/640aa095ab13792d21032a9e171c77bd
		I changed the code a bit to directly generate the result and optionally
		the generator function itself.
	}
]

; range generator (numbers)
range: function [f t /step s][
	unless step [s: 1]
	n: f
	collect [while [n <= t][
		keep n
		n: n + s
	]]
]
	
; list comprehension
lc: function [rule /code] [
    parse rule [
        some [
            s: word! 'in skip
                (in: last reduce/into ['foreach s/1 s/3 make block! 4] in)
            | 'if skip
                (in: last reduce/into ['if to-paren s/2 make block! 4] in)
            | skip '|
                (res: s/1 fun: in: make block! 4)
            | (reduce/into ['reduce/into res 'tail 'out] in) break
        ]
    ]
	f: has [out] compose [out: make block! 10 (fun) out]
	either code [:f][f]
]

; print rosetta code task: pythagorean triples
print mold sort lc [[reduce [a b c]] |
	a in (range 1 20)
	b in (range 1 20)
	c in (range 1 20)
	if [all [(a ** 2) + (b ** 2) = (c ** 2)  a < b  b < c]]
]
