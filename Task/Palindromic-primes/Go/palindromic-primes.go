package main

import (
    "fmt"
    "rcu"
)

func reversed(n int) int {
    rev := 0
    for n > 0 {
        rev = rev*10 + n%10
        n /= 10
    }
    return rev
}

func main() {
    primes := rcu.Primes(99999)
    var pals []int
    for _, p := range primes {
        if p == reversed(p) {
            pals = append(pals, p)
        }
    }
    fmt.Println("Palindromic primes under 1,000:")
    var smallPals, bigPals []int
    for _, p := range pals {
        if p < 1000 {
            smallPals = append(smallPals, p)
        } else {
            bigPals = append(bigPals, p)
        }
    }
    rcu.PrintTable(smallPals, 10, 3, false)
    fmt.Println()
    fmt.Println(len(smallPals), "such primes found.")

    fmt.Println("\nAdditional palindromic primes under 100,000:")
    rcu.PrintTable(bigPals, 10, 6, true)
    fmt.Println()
    fmt.Println(len(bigPals), "such primes found,", len(pals), "in all.")
}
