Number extend [
    nthRoot: n [
	|x0 m x1|
	x0 := (self / n) asFloatD.
	m := n - 1.
	[true] whileTrue: [
	    x1 := ( (m * x0) + (self/(x0 raisedTo: m))) / n.
	    ((x1 - x0) abs) < ((x0 * 1e-9) abs)
		ifTrue: [ ^ x1 ].
	    x0 := x1
	]
    ]
].
