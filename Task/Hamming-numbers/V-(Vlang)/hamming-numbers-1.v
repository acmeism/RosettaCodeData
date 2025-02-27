import math.big

fn min(a big.Integer, b big.Integer) big.Integer {
    if a < b {return a}
    return b
}

fn hamming(n int) []big.Integer {
    mut h := []big.Integer{len: n}
    h[0] = big.one_int
    two, three, five    := big.two_int, big.integer_from_int(3), big.integer_from_int(5)
    mut next2, mut next3, mut next5 := big.two_int, big.integer_from_int(3), big.integer_from_int(5)
    mut i, mut j, mut k := 0, 0, 0
    for m in 1..h.len {
        h[m] = min(next2, min(next3, next5))
        if h[m] == next2 {
            i++
            next2 = two * h[i]
        }
        if h[m] == next3 {
            j++
            next3 = three * h[j]
        }
        if h[m] == next5 {
            k++
            next5 = five * h[k]
        }
    }
    return h
}

fn main() {
    h := hamming(int(1e6))
    println(h[..20])
    println(h[1691-1])
    println(h[h.len-1])
}
