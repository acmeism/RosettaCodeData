fn jacobi(aa u64, na u64) ?int {
    mut a := aa
    mut n := na
    if n%2 == 0 {
        return error("'n' must be a positive odd integer")
    }
    a %= n
    mut result := 1
    for a != 0 {
        for a%2 == 0 {
            a /= 2
            nn := n % 8
            if nn == 3 || nn == 5 {
                result = -result
            }
        }
        a, n = n, a
        if a%4 == 3 && n%4 == 3 {
            result = -result
        }
        a %= n
    }
    if n == 1 {
        return result
    }
    return 0
}

fn main() {
    println("Using hand-coded version:")
    println("n/a  0  1  2  3  4  5  6  7  8  9")
    println("---------------------------------")
    for n := u64(1); n <= 17; n += 2 {
        print("${n:2} ")
        for a := u64(0); a <= 9; a++ {
            t := jacobi(a, n)?
            print(" ${t:2}")
        }
        println('')
    }
}
