package main

import (
    "fmt"
    "rcu"
    "strings"
)

func main() {
    limit := 100_000
    primes := rcu.Primes(limit * 10)
    var results []int
    for _, p := range primes {
        if p < 1000 || p > 99999 {
            continue
        }
        ps := fmt.Sprintf("%s", p)
        if strings.Contains(ps, "123") {
            results = append(results, p)
        }
    }
    climit := rcu.Commatize(limit)
    fmt.Printf("Primes under %s which contain '123' when expressed in decimal:\n", climit)
    for i, p := range results {
        fmt.Printf("%7s ", rcu.Commatize(p))
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }
    fmt.Println("\n\nFound", len(results), "such primes under", climit, "\b.")

    limit = 1_000_000
    climit = rcu.Commatize(limit)
    count := len(results)
    for _, p := range primes {
        if p < 100_000 {
            continue
        }
        ps := fmt.Sprintf("%s", p)
        if strings.Contains(ps, "123") {
            count++
        }
    }
    fmt.Println("\nFound", count, "such primes under", climit, "\b.")
}
