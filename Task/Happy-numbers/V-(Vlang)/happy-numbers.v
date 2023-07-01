fn happy(h int) bool {
    mut m := map[int]bool{}
    mut n := h
    for n > 1 {
        m[n] = true
        mut x := 0
        for x, n = n, 0; x > 0; x /= 10 {
            d := x % 10
            n += d * d
        }
        if m[n] {
            return false
        }
    }
    return true
}

fn main() {
    for found, n := 0, 1; found < 8; n++ {
        if happy(n) {
            print("$n ")
            found++
        }
    }
    println('')
}
