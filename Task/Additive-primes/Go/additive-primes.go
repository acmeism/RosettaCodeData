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
    fmt.Println("Additive primes less than 500:")
    i := 2
    count := 0
    for {
        if isPrime(i) && isPrime(sumDigits(i)) {
            count++
            fmt.Printf("%3d  ", i)
            if count%10 == 0 {
                fmt.Println()
            }
        }
        if i > 2 {
            i += 2
        } else {
            i++
        }
        if i > 499 {
            break
        }
    }
    fmt.Printf("\n\n%d additive primes found.\n", count)
}
