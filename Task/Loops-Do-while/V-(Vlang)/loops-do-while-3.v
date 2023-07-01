fn main() {
	// do-while loop 1
	mut n1 := 2
	for n1 < 6 {
		n1 *= 2
	}
	println(n1) // prt 8
	// do-while loop 2
	mut n2 := 2
	for ok := true; ok; ok = n2%8 != 0 {
	    n2 *= 2
	}
	println(n2) // prt 8
	// do-while loop 3
	mut n3 := 2
	for {
		n3 *= 2
		if n3 >= 6 {
			break
		}
	}
	println(n3) // prt 8
}
