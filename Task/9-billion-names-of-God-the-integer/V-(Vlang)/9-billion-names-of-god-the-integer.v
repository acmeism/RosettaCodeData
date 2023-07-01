import math.big

fn int_min(a int, b int) int {
    if a < b {
        return a
    } else {
        return b
    }
}

fn cumu (mut cache [][]big.Integer, n int) []big.Integer {
    for y := cache.len; y <= n; y++ {
        mut row := [big.zero_int]
        for x := 1; x <= y; x++ {
            cache_value := cache[y-x][int_min(x, y-x)]
            row << row[row.len-1] + cache_value
        }
        cache << row
    }
    return cache[n]
}
fn main() {

	mut cache := [[big.one_int]]


	row := fn[mut cache](n int) {
		e := cumu(mut cache, n)
		for i := 0; i < n; i++ {
			print(" ${e[i+1]-e[i]} ")
		}
		println('')
	}

	println("rows:")
	for x := 1; x < 11; x++ {
		row(x)
	}
	println('')

	println("sums:")
	for num in [23, 123, 1234, 12345] {
		r := cumu(mut cache, num)
		println("$num ${r[r.len-1]}")
	}
}
