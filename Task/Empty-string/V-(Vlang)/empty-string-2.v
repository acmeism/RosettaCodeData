fn test(s string) {
	if s.len() == 0 {
		println("empty")
	} else {
		println("not empty")
	}
}

fn main() {
	// assign an empty string to a variable.
	str1 := ""
	str2 := " "
	// check if a string is empty.
	test(str1) // prt empty
	// check that a string is not empty.
	test(str2) // prt not empty
}
