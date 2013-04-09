(1 to: 100) do:
	[:n |
		((n \\ 3)*(n \\ 5)) isZero
                        ifFalse: [Transcript show: n].
		(n \\ 3) isZero
			ifTrue: [Transcript show: 'Fizz'].
		(n \\ 5) isZero
			ifTrue: [Transcript show: 'Buzz'].
		Transcript cr.]
