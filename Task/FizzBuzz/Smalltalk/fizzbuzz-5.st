1 to: 100 do: [:n | |r|
	r := n rem: 15.
	Transcript show: (r isZero
	   ifTrue:['fizzbuzz']
	   ifFalse: [(#(3 6 9 12) includes: r)
		ifTrue:['fizz']
		ifFalse:[((#(5 10) includes: r))
			ifTrue:['buzz']
			ifFalse:[n]]]);
	cr].
