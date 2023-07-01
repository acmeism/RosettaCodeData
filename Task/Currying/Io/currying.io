curry := method(fn,
	a := call evalArgs slice(1)
	block(
		b := a clone appendSeq(call evalArgs)
		performWithArgList("fn", b)
	)
)

// example:
increment := curry( method(a,b,a+b), 1 )
increment call(5)
// result => 6
