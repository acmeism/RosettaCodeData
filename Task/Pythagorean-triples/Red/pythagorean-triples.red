Red [
	title: "Pythagorean Triples"
	author: "hinjolicoius"
	notes: {Based on Arturo's example}
]

#include %filter.red
#include %gcd.red

triples: []
tri: 0
pri: 0
repeat a 1000 [
	repeat b 1000 [
		repeat c 1000 [
			either (sum reduce [a b c]) < 100 [
				if ((a * a) + (b * b)) = (c * c)  [
					trip: sort reduce [a b c]
					if none? find/only triples trip [
						tri: tri + 1
						prin [tri "." a b c "->" a + b + c]
						if (gcd trip/1 trip/2) = 1 [pri: pri + 1 prin [" -> Primitive!" pri]]
						print ""
						append/only triples trip
					]
				]
			][break]
		]
	]
]
print mold triples
print ["Triples:" length? triples]
prims: filter triples [(gcd _e/1 _e/2) = 1]
print mold prims
print ["Primitives:" length? prims]
