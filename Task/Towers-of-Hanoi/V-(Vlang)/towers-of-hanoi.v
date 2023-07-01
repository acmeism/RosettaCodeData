fn main() {
	hanoi(4, "A", "B", "C")
}

fn hanoi(n u64, a string, b string, c string) {
    if n > 0 {
        hanoi(n - 1, a, c, b)
        println("Move disk from ${a} to ${c}")
        hanoi(n - 1, b, a, c)
    }
}
