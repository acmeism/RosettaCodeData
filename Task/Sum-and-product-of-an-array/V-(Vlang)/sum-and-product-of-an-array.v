fn main() {
	values := [1, 2, 3, 4, 5]
	mut sum, mut prod := 0, 1
	for val in values {
		sum  += val
		prod *= val
	}
	println("sum: $sum\nproduct: $prod")
}
