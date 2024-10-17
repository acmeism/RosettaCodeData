import rand

fn main() {
	flag := ["Red","White","Blue"]
	mut balls := [10]string{}
	mut color :=""
	mut number := 0

	print("Random: |")
	for idx in 0..10 {
		number = rand.int_in_range(0, 3) or {println("Error: invalid number") exit(1)}
		balls[idx] = flag[number]
		print("${balls[idx]}" + " |")
	}
	println("")
	
	print("Sorted: |")
	for idx in 0..3 {
		color = flag[idx]
		for jdx in 0..10 {
			if balls[jdx] == color {print("${balls[jdx]}" + " |")}
		}
	}
	println("")
}
