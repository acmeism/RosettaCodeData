fn is_prime(n u64) bool {
    if n % 2 == 0 {
        return n == 2
    }
    if n % 3 == 0 {
        return n == 3
    }
    mut d := u64(5)
    for d * d <= n {
        if n % d == 0 {
            return false
        }
        d += 2
        if n % d == 0 {
            return false
        }
        d += 4
    }
    return true
}
const limit = 42
fn main() {
    for i, n := u64(limit), 0; n<limit; i++ {
        if is_prime(i) {
            n++
            println("n = ${n:-2}  ${i:19}")
            i += i - 1
        }
    }
}
