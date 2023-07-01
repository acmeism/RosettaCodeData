Red [
	Source:     https://github.com/vazub/rosetta-red
	Tabs:       4
]

comment {
	Vector type is one of base datatypes in Red, with all arithmetic already implemented.
	
	Caveats to keep in mind:
	- Arithmetic on a single vector will modify the vector in place, so we use copy to avoid that
	- Division result on integer vectors will get truncated, use floats for decimal precision
}
	
v1: make vector! [5.0 7.0]
v2: make vector! [2.0 3.0]

prin pad "v1: " 10 print v1
prin pad "v2: " 10 print v2
prin pad "v1 + v2: " 10 print v1 + v2
prin pad "v1 - v2: " 10 print v1 - v2
prin pad "v1 * 11" 10 print (copy v1) * 11
prin pad "v1 / 2" 10 print (copy v1) / 2
