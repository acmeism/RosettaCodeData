fn main() {
	mut value := 0
	for ok := true; ok; ok = value%6 != 0 {
		value++
		println(value)
	}
}
