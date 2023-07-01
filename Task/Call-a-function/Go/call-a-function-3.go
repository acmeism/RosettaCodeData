	h("ex1")
	h("ex2", 1, 2)
	h("ex3", 1, 2, 3, 4)
	// such functions can also be called by expanding a slice:
	list := []int{1,2,3,4}
	h("ex4", list...)
	// but again, not mixed with other arguments, this won't compile:
	//h("fail", 2, list...)
