package main

import (
    "fmt"
    "rcu"
)

func main() {
    primes := rcu.Primes(1000)
    maxSum := 0
    for _, p := range primes {
        maxSum += p
    }
    c := rcu.PrimeSieve(maxSum, true)
    primeSum := 0
    var results []int
    for _, p := range primes {
        primeSum += p
        if !c[primeSum] {
            results = append(results, p)
        }
    }
    fmt.Println("Primes 'p' under 1000 where the sum of all primes <= p is also prime:")
    for i, p := range results {
        fmt.Printf("%4d ", p)
        if (i+1)%7 == 0 {
            fmt.Println()
        }
    }
    fmt.Println("\nFound", len(results), "such primes")
}
