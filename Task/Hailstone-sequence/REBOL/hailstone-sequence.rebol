hail: func [
	"Returns the hailstone sequence for n"
	n [integer!]
	/local seq
] [
	seq: copy reduce [n]
	while [n <> 1] [
		append seq n: either n % 2 == 0 [n / 2] [3 * n + 1]
	]
	seq
]

hs27: hail 27
print [
	"the hail sequence of 27 has length" length? hs27
	"and has the form " copy/part hs27 3 "..."
	back back back tail hs27
]

maxN: maxLen: 0
repeat n 99999 [
	if (len: length? hail n) > maxLen [
		maxN: n
		maxLen: len
	]
]

print [
	"the number less than 100000 with the longest hail sequence is"
	maxN "with length" maxLen
]
