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

func countPrimeFactors(n int) int {
    switch {
    case n == 1:
        return 0
    case isPrime(n):
        return 1
    default:
        count, f := 0, 2
        for {
            if n%f == 0 {
                count++
                n /= f
                if n == 1 {
                    return count
                }
                if isPrime(n) {
                    f = n
                }
            } else if f >= 3 {
                f += 2
            } else {
                f = 3
            }
        }
        return count
    }
}

func main() {
    const max = 120
    fmt.Println("The attractive numbers up to and including", max, "are:")
    count := 0
    for i := 1; i <= max; i++ {
        n := countPrimeFactors(i)
        if isPrime(n) {
            fmt.Printf("%4d", i)
            count++
            if count % 20 == 0 {
                fmt.Println()
            }
        }
    }
    fmt.Println()
}
