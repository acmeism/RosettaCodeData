fn main() {
	mut value := 0
	for {
		value++
		println(value)
                if value%6 != 0 {
                        break
                }
	}
}
