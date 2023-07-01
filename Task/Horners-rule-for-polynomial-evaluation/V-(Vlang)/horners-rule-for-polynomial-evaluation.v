fn horner(x i64, c []i64) i64 {
    mut acc := i64(0)
    for i := c.len - 1; i >= 0; i-- {
        acc = acc*x + c[i]
    }
    return acc
}

fn main() {
    println(horner(3, [i64(-19), 7, -4, 6]))
}
