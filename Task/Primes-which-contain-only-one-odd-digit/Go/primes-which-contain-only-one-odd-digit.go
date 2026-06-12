package main

import (
    "fmt"
    "rcu"
)

func allButOneEven(prime int) bool {
    digits := rcu.Digits(prime, 10)
    digits = digits[:len(digits)-1]
    allEven := true
    for _, d := range digits {
        if d&1 == 1 {
            allEven = false
            break
        }
    }
    return allEven
}

func main() {
    const (
        LIMIT      = 999
        LIMIT2     = 9999999999
        MAX_DIGITS = 3
    )
    primes := rcu.Primes(LIMIT)
    var results []int
    for _, prime := range primes[1:] {
        if allButOneEven(prime) {
            results = append(results, prime)
        }
    }
    fmt.Println("Primes under", rcu.Commatize(LIMIT+1), "which contain only one odd digit:")
    for i, p := range results {
        fmt.Printf("%*s ", MAX_DIGITS, rcu.Commatize(p))
        if (i+1)%9 == 0 {
            fmt.Println()
        }
    }
    fmt.Println("\nFound", len(results), "such primes.\n")

    primes = rcu.Primes(LIMIT2)
    count := 0
    pow := 10
    for _, prime := range primes[1:] {
        if allButOneEven(prime) {
            count++
        }
        if prime > pow {
            fmt.Printf("There are %7s such primes under %s\n", rcu.Commatize(count), rcu.Commatize(pow))
            pow *= 10
        }
    }
    fmt.Printf("There are %7s such primes under %s\n", rcu.Commatize(count), rcu.Commatize(pow))
}
