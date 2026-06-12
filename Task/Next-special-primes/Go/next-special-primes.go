package main

import "fmt"

func sieve(limit int) []bool {
    limit++
    // True denotes composite, false denotes prime.
    c := make([]bool, limit) // all false by default
    c[0] = true
    c[1] = true
    // no need to bother with even numbers over 2 for this task
    p := 3 // Start from 3.
    for {
        p2 := p * p
        if p2 >= limit {
            break
        }
        for i := p2; i < limit; i += 2 * p {
            c[i] = true
        }
        for {
            p += 2
            if !c[p] {
                break
            }
        }
    }
    return c
}

func main() {
    c := sieve(1049)
    fmt.Println("Special primes under 1,050:")
    fmt.Println("Prime1 Prime2 Gap")
    lastSpecial := 3
    lastGap := 1
    fmt.Printf("%6d %6d %3d\n", 2, 3, lastGap)
    for i := 5; i < 1050; i += 2 {
        if !c[i] && (i-lastSpecial) > lastGap {
            lastGap = i - lastSpecial
            fmt.Printf("%6d %6d %3d\n", lastSpecial, i, lastGap)
            lastSpecial = i
        }
    }
}
