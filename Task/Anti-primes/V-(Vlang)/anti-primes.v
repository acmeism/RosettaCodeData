fn count_divisors(n int) int {
    if n < 2 {
        return 1
    }
    mut count := 2 // 1 and n
    for i := 2; i <= n/2; i++ {
        if n%i == 0 {
            count++
        }
    }
    return count
}

fn main() {
    println("The first 20 anti-primes are:")
    mut max_div := 0
    mut count := 0
    for n := 1; count < 20; n++ {
        d := count_divisors(n)
        if d > max_div {
            print("$n ")
            max_div = d
            count++
        }
    }
    println('')
}
