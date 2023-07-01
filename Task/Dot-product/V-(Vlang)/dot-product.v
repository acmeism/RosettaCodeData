fn dot(x []int, y []int) !int {
    if x.len != y.len {
        return error("incompatible lengths")
    }
	mut r := 0
    for i, xi in x {
        r += xi * y[i]
    }
    return r
}

fn main() {
    d := dot([1, 3, -5], [4, -2, -1])!

    println(d)
}
