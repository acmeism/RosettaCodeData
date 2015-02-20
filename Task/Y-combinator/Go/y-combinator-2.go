func Y(f FuncFunc) Func {
	return func(x int) int {
		return f(Y(f))(x)
	}
}
