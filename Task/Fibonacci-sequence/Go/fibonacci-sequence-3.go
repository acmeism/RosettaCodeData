func fibNumber() func() int {
	fib1, fib2 := 0, 1
	return func() int {
		fib1, fib2 = fib2, fib1 + fib2
		return fib1
	}
}

func fibSequence(n int) int {
	f := fibNumber()
	fib := 0
	for i := 0; i < n; i++ {
		fib = f()
	}
	return fib
}
