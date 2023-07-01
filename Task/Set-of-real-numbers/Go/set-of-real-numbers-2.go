	A := Inter(open(0, 10), func(x float64) bool {
		return math.Abs(math.Sin(math.Pi*x*x)) > .5
	})
	B := Inter(open(0, 10), func(x float64) bool {
		return math.Abs(math.Sin(math.Pi*x)) > .5
	})
	C := Diff(A, B)
	// Can't get lengths, can only test for ∈
	for x := float64(5.98); x < 6.025; x += 0.01 {
		fmt.Printf("%.2f ∈ A−B: %t\n", x, C(x))
	}
