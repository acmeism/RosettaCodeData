// Enums can have methods
mut c := Cycle.one
for _ in 0 .. 5 {
	println(c)
	c = c.next()
}
