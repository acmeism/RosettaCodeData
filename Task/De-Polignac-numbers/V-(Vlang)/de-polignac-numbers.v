fn is_prime(n int) bool {
    if n < 2 {return false}
	else if n % 2 == 0 {return n == 2}
	else if n % 3 == 0 {return n == 3}
	else {
        mut d := 5
        for d * d <= n {
            if n % d == 0 {return false}
            d += 2
            if n % d == 0 {return false}
            d += 4
        }
        return true
    }
}

fn pow2floor(n int) int {
    mut c := 0
    mut n2 := n
    for n2 > 0 {
        c++
        n2 >>= 1
    }
    return c
}

fn is_polignac(n int) bool {
    mut result := false
    for exp in 0..pow2floor(n) {
        result ||= is_prime(n-(1<<exp))
    }
    return !result
}

fn test() {
    mut n := 1
    mut c := 1
    for c < 10000 {
        // Uncomment for debug output:
        // println ("    ${n}")
        if is_polignac(n) {
            if c <= 50 {println("${n}")}
            if c == 1000 {println("${c}: ${n}")}
            c ++
        }
        n += 2
    }
    println("${c}: ${n}")
}

fn main() {
    test()
}
