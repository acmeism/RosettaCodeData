package main

import (
    "fmt"
    "math"
)

func sieve(limit uint64) []uint64 {
    primes := []uint64{2}
    c := make([]bool, limit+1) // composite = true
    // no need to process even numbers > 2
    p := uint64(3)
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
    for i := uint64(3); i <= limit; i += 2 {
        if !c[i] {
            primes = append(primes, i)
        }
    }
    return primes
}

func squareFree(from, to uint64) (results []uint64) {
    limit := uint64(math.Sqrt(float64(to)))
    primes := sieve(limit)
outer:
    for i := from; i <= to; i++ {
        for _, p := range primes {
            p2 := p * p
            if p2 > i {
                break
            }
            if i%p2 == 0 {
                continue outer
            }
        }
        results = append(results, i)
    }
    return
}

const trillion uint64 = 1000000000000

func main() {
    fmt.Println("Square-free integers from 1 to 145:")
    sf := squareFree(1, 145)
    for i := 0; i < len(sf); i++ {
        if i > 0 && i%20 == 0 {
            fmt.Println()
        }
        fmt.Printf("%4d", sf[i])
    }

    fmt.Printf("\n\nSquare-free integers from %d to %d:\n", trillion, trillion+145)
    sf = squareFree(trillion, trillion+145)
    for i := 0; i < len(sf); i++ {
        if i > 0 && i%5 == 0 {
            fmt.Println()
        }
        fmt.Printf("%14d", sf[i])
    }

    fmt.Println("\n\nNumber of square-free integers:\n")
    a := [...]uint64{100, 1000, 10000, 100000, 1000000}
    for _, n := range a {
        fmt.Printf("  from %d to %d = %d\n", 1, n, len(squareFree(1, n)))
    }
}
