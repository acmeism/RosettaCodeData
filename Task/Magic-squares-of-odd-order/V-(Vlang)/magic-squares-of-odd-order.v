fn main() {
	mut n, mut x := 9, 0
	println("the square order is : ${n}" + "\n")
	for i in 1 .. n + 1 {
		for j in 1 .. n + 1 {
			x = (i * 2 - j + n - 1) % n * n + (i * 2 + j - 2) % n + 1
			print(" ${x:2} ")
		}
		println("")
	}
	println("\n" + "the magic number is : ${n * (n * n+1) / 2}")
}
