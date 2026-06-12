package main

import "fmt"

func isPrime(n uint64) bool {
    if n < 2 {
        return false
    }
    if n%2 == 0 {
        return n == 2
    }
    if n%3 == 0 {
        return n == 3
    }
    d := uint64(5)
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

func main() {
    f1 := uint64(1)
    f2 := f1
    count := 0
    limit := 12 // as far as we can get without using big.Int
    fmt.Printf("The first %d prime Fibonacci numbers are:\n", limit)
    for count < limit {
        f3 := f1 + f2
        if isPrime(f3) {
            fmt.Printf("%d ", f3)
            count++
        }
        f1 = f2
        f2 = f3
    }
    fmt.Println()
}
