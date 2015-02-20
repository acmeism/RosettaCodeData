	f()
	g(1, 2.0)
	// If f() is defined to return exactly the number and type of
	// arguments that g() accepts than they can be used in place:
	g(f())
	// But only without other arguments, this won't compile:
	//h("fail", f())
	// But this will:
	g(g(1, 2.0), 3.0)
