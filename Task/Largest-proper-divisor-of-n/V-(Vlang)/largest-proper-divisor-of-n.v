fn largest_proper_divisor(n int) int {
    for i := 2; i*i <= n; i++ {
        if n%i == 0 {
            return n / i
        }
    }
    return 1
}

fn main() {
    println("The largest proper divisors for numbers in the interval [1, 100] are:")
    print(" 1  ")
    for n := 2; n <= 100; n++ {
        if n%2 == 0 {
            print("${n/2:2}  ")
        } else {
            print("${largest_proper_divisor(n):2}  ")
        }
        if n%10 == 0 {
            println('')
        }
    }
}
