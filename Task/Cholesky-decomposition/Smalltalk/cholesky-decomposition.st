FloatMatrix>>#cholesky
	| l |
	l := FloatMatrix zero: numRows.
	1 to: numRows do: [:i |
		1 to: i do: [:k | | rowSum lkk factor aki partialSum |
			i = k
				ifTrue: [
					rowSum := (1 to: k - 1) sum: [:j | | lkj |
						lkj := l at: j @ k.
						lkj squared].
					lkk := (self at: k @ k) - rowSum.
					lkk := lkk sqrt.
					l at: k @ k put: lkk]
				ifFalse: [
					factor := l at: k @ k.
					aki := self at: k @ i.
					partialSum := (1 to: k - 1) sum: [:j | | ljk lji |
						lji := l at: j @ i.
						ljk := l at: j @ k.
						lji * ljk].
					l at: k @ i put: aki - partialSum * factor reciprocal]]].
	^l
