limit := 10 raisedToInteger: 84.
tape := Set new.

hammingProcess := [:newHamming|
	(newHamming <= limit)
		ifTrue:
			[| index |
			index := tape scanFor: newHamming.
			(tape array at: index)
				ifNil:
					[tape atNewIndex: index put: newHamming asSetElement.
					hammingProcess value: newHamming * 2.
					hammingProcess value: newHamming * 3.
					hammingProcess value: newHamming * 5]]].

hammingProcess value: 1.

sc := tape asSortedCollection.
sc first: 20. "a SortedCollection(1 2 3 4 5 6 8 9 10 12 15 16 18 20 24 25 27 30 32 36)"
sc at: 1691. "2125764000"
sc at: 1000000. "519312780448388736089589843750000000000000000000000000000000000000000000000000000000"
