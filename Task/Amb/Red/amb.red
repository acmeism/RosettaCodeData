Red ["Amb operator"]

findblock: function [
	blk [block!]
][
	foreach w blk [
		if all [word? w block? get w] [return w]
		if block? w [findblock w]
	]
]

amb: function [
	cond [block!]
][
	either b: findblock cond [
		foreach a get b [
			cond2: replace/all/deep copy/deep cond b a
			if amb cond2 [set b a return true]]	
	][do cond]	
]

; examples

x: [1 2 3 4]
y: [4 5 6]
z: [5 2]
print amb [x * y * z = 8]
print [x y z]

a: ["the" "that" "a"]
b: ["frog" "elephant" "thing"]
c: ["walked" "treaded" "grows"]
d: ["slowly" "quickly"]
print amb [
	all [
		equal? last a first b
		equal? last b first c
		equal? last c first d
	]
]
print [a b c d]
