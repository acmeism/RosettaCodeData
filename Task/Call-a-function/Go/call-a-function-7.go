	a, b := f()              // multivalue return
	_, c := f()              // only some of a multivalue return
	d := g(a, c)             // single return value
	e, i := g(d, b), g(d, 2) // multiple assignment
