fn new_counter() fn () int {
	mut i := 0
	return fn [mut i] () int {
		i++
		return i
	}
}

count := new_counter()
println(count()) // 1
println(count()) // 2
println(count()) // 3
