perimeter := [:triangle | triangle reduce: #+].

squaredArea := [:triangle |
	| s  |
	s := (perimeter value: triangle) / 2.
	triangle inject: s into: [:a2 :edge | s - edge * a2]].

isPrimitive := [:triangle | (triangle reduce: #gcd:) = 1].

isHeronian := [:triangle | (squaredArea value: triangle) sqrt isInteger].

heroGenerator := Generator on: [:generator |
	1 to: 200 do: [:a |
	a to: 200 do: [:b |
	b to: (a+b-1 min: 200) do: [:c |
		| triangle |
		triangle := {a. b. c.}.
		((isPrimitive value: triangle) and: [isHeronian value: triangle])
			ifTrue: [generator nextPut: triangle]]]]].

heronians := heroGenerator contents.
sorter := squaredArea ascending , perimeter ascending , #third ascending , #second ascending , #first ascending.
sorted := heronians sorted: sorter.
area210 := sorted select: [:triangle | (squaredArea value: triangle) = 210 squared].

header := [:title |
	Transcript cr; cr; nextPutAll: title; cr.
	#(peri area a b c) do: [:s | Transcript nextPutAll: s; tab]].
tabulate := [:t |
	Transcript cr.
	Transcript print: (perimeter value: t); tab.
	Transcript print: (squaredArea value: t) sqrt.
	t do: [:edge | Transcript tab; print: edge].].

Transcript cr; print: heronians size; nextPutAll: ' heronians triangles of side <= 200 where found'.
header value: 'first 10 sorted by area, then perimeter, the largest side'.
(sorted first: 10) do: tabulate.
header value: 'heronians of area 210'.
area210 do: tabulate.

Transcript flush.
