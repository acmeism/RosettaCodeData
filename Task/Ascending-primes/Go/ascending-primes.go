package main

import (
    "fmt"
    "rcu"
    "sort"
)

var ascPrimesSet = make(map[int]bool) // avoids duplicates

func generate(first, cand, digits int) {
    if digits == 0 {
        if rcu.IsPrime(cand) {
            ascPrimesSet[cand] = true
        }
        return
    }
    for i := first; i < 10; i++ {
        next := cand*10 + i
        generate(i+1, next, digits-1)
    }
}

func main() {
    for digits := 1; digits < 10; digits++ {
        generate(1, 0, digits)
    }
    le := len(ascPrimesSet)
    ascPrimes := make([]int, le)
    i := 0
    for k := range ascPrimesSet {
        ascPrimes[i] = k
        i++
    }
    sort.Ints(ascPrimes)
    fmt.Println("There are", le, "ascending primes, namely:")
    for i := 0; i < le; i++ {
        fmt.Printf("%8d ", ascPrimes[i])
        if (i+1)%10 == 0 {
            fmt.Println()
        }
    }
}
