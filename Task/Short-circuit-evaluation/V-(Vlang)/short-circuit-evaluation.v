fn main() {
	test_me(false, false)
	test_me(false, true)
	test_me(true, false)
	test_me(true, true)
}

fn a(v bool) bool {
    print("a")
    return v
}

fn b(v bool) bool {
    print("b")
    return v
}

fn test_me(i bool, j bool) {
    println("Testing a(${i}) && b(${j})")
    print("Trace:  ")
    println("\nResult: ${a(i) && b(j)}")

    println("Testing a(${i})} || b(${j})")
    print("Trace:  ")
    println("\nResult: ${a(i) || b(j)}")
	println("")
}
