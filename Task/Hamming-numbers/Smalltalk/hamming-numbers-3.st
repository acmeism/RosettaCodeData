tape := Heap with: 1 -> 1.
hammingStream :=
	[| next |
	next := tape removeFirst.
	next value <= 2 ifTrue: [tape add: next key * 2 -> 2].
	next value <= 3 ifTrue: [tape add: next key * 3 -> 3].
	next value <= 5 ifTrue: [tape add: next key * 5 -> 5].
	next key]
		reading.

hammingStream read: 20. "get first 20 values => #(1 2 3 4 5 6 8 9 10 12 15 16 18 20 24 25 27 30 32 36)"
hammingStream ++ 1670. "skip the next 1670 values"
hammingStream get. "and the 1691th value is => 2125764000".
hammingStream ++ (999999 - 1691). "now skip more to position at 999,999".
hammingStream get. "and the 1,000,000th value is =>  519312780448388736089589843750000000000000000000000000000000000000000000000000000000".
tape size. "See how many we have buffered =>  24904"
