func Ackermann(m, n uint) uint {
	switch 0 {
	case m:
		return n + 1
	case n:
		return Ackermann(m - 1, 1)
	}
	return Ackermann(m - 1, Ackermann(m, n - 1))
}
