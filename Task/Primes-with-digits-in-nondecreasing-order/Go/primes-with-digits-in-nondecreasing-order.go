package main

import (
    "fmt"
    "rcu"
)

func nonDescending(p int) bool {
    var digits []int
    for p > 0 {
        digits = append(digits, p%10)
        p = p / 10
    }
    for i := 0; i < len(digits)-1; i++ {
        if digits[i+1] > digits[i] {
            return false
        }
    }
    return true
}

func main() {
    primes := rcu.Primes(999)
    var nonDesc []int
    for _, p := range primes {
        if nonDescending(p) {
            nonDesc = append(nonDesc, p)
        }
    }
    fmt.Println("Primes below 1,000 with digits in non-decreasing order:")
    for i, n := range nonDesc {
        fmt.Printf("%3d ", n)
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }
    fmt.Printf("\n%d such primes found.\n", len(nonDesc))
}
