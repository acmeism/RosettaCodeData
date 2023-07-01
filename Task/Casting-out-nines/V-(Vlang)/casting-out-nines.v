fn main() {
    println(cast_out(16, 1, 255))
    println("")
    println(cast_out(10, 1, 99))
    println("")
    println(cast_out(17, 1, 288))
}

fn cast_out(base int, start int, end int) []int {
    b := []int{len: base - 1, init: index}
	ran := b.filter(it % b.len == (it * it) % b.len)
	mut x, mut k := start / b.len, 0
	mut result := []int{}
    for {
        for n in ran {
            k = b.len * x + n
            if k < start {continue}
            if k > end {return result}
            result << k
        }
        x++
    }
	return result
}
