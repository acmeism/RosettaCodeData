package main

import (
    "fmt"
    "rcu"
    "sort"
)

func main() {
    const LIMIT = 99
    primes := rcu.Primes(LIMIT)
    rmap := make(map[int]bool)
    for _, p := range primes {
        for _, q := range primes {
            var pq int
            if q < 10 {
                pq = p*10 + q
            } else {
                pq = p*100 + q
            }
            if rcu.IsPrime(pq) {
                rmap[pq] = true
            }
        }
    }
    results := make([]int, len(rmap))
    i := 0
    for k := range rmap {
        results[i] = k
        i++
    }
    sort.Ints(results)
    fmt.Println("Two primes under 100 concatenated together to form another prime:")
    for i, p := range results {
        fmt.Printf("%5s ", rcu.Commatize(p))
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }
    fmt.Println("\n\nFound", len(results), "such concatenated primes.")
}
