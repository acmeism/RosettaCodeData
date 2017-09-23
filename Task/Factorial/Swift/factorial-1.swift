func factorial(_ n: Int) -> Int {
	return n < 2 ? 1 : (2...n).reduce(1, *)
}
