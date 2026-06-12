func assert(t bool, s string) {
	if !t {
		panic(s)
	}
}
//…
	assert(c == 0, "some text here")
