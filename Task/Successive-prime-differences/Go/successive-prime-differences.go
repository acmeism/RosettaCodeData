package main

import "fmt"

func sieve(limit int) []int {
    primes := []int{2}
    c := make([]bool, limit+1) // composite = true
    // no need to process even numbers > 2
    p := 3
    for {
        p2 := p * p
        if p2 > limit {
            break
        }
        for i := p2; i <= limit; i += 2 * p {
            c[i] = true
        }
        for {
            p += 2
            if !c[p] {
                break
            }
        }
    }
    for i := 3; i <= limit; i += 2 {
        if !c[i] {
            primes = append(primes, i)
        }
    }
    return primes
}

func successivePrimes(primes, diffs []int) [][]int {
    var results [][]int
    dl := len(diffs)
outer:
    for i := 0; i < len(primes)-dl; i++ {
        group := make([]int, dl+1)
        group[0] = primes[i]
        for j := i; j < i+dl; j++ {
            if primes[j+1]-primes[j] != diffs[j-i] {
                group = nil
                continue outer
            }
            group[j-i+1] = primes[j+1]
        }
        results = append(results, group)
        group = nil
    }
    return results
}

func main() {
    primes := sieve(999999)
    diffsList := [][]int{{2}, {1}, {2, 2}, {2, 4}, {4, 2}, {6, 4, 2}}
    fmt.Println("For primes less than 1,000,000:-\n")
    for _, diffs := range diffsList {
        fmt.Println("  For differences of", diffs, "->")
        sp := successivePrimes(primes, diffs)
        if len(sp) == 0 {
            fmt.Println("    No groups found")
            continue
        }
        fmt.Println("    First group   = ", sp[0])
        fmt.Println("    Last group    = ", sp[len(sp)-1])
        fmt.Println("    Number found  = ", len(sp))
        fmt.Println()
    }
}
