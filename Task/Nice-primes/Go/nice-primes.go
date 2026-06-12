package main

import "fmt"

func isPrime(n int) bool {
    switch {
    case n < 2:
        return false
    case n%2 == 0:
        return n == 2
    case n%3 == 0:
        return n == 3
    default:
        d := 5
        for d*d <= n {
            if n%d == 0 {
                return false
            }
            d += 2
            if n%d == 0 {
                return false
            }
            d += 4
        }
        return true
    }
}

func sumDigits(n int) int {
    sum := 0
    for n > 0 {
        sum += n % 10
        n /= 10
    }
    return sum
}

func main() {
    fmt.Println("Nice primes in the interval (500, 900) are:")
    c := 0
    for i := 501; i <= 999; i += 2 {
        if isPrime(i) {
            s := i
            for s >= 10 {
                s = sumDigits(s)
            }
            if s == 2 || s == 3 || s == 5 || s == 7 {
                c++
                fmt.Printf("%2d: %d -> Σ = %d\n", c, i, s)
            }
        }
    }
}
